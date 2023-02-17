//
//  FirstQuestionViewController.swift
//  Affirma
//
//  Created by Airblack on 07/01/23.
//

import Foundation
import UIKit

class FirstQuestionViewControllerFactory: NSObject {
    class func produce() -> FirstQuestionViewController {
        let firstQuesVC = FirstQuestionViewController(nibName: "FirstQuestionViewController",
                                                      bundle: nil)
        return firstQuesVC
    }
}

class FirstQuestionViewController: BaseViewController {
    
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cta: GenericButtonView!
    
    fileprivate var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        handleTap()
        disableCTA()
        nameTextField.delegate = self
        EventManager.shared.trackEvent(event: .landedOnNameScreen)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
        
    }
    
    private func setUI() {
        
        mediaView.render(withImage: nil,
                         withVideo: nil,
                         withGif: "fourthStep")
        
        nameTextField.attributedPlaceholder = Utility
            .getAttributedString(font: Font(.installed(.avenirLight),
                                            size: .custom(24.0)).instance,
                                 color: Colors.white_E5E5E5.withAlpha(0.5),
                                 text: "John")
        
    }
    
    private func handleTap() {
        cta.customCtaCtaClicked = { tag in
            Task {
                let properties = ["name": self.name ?? ""]
                EventManager.shared.trackEvent(event: .nameEntered,
                                               properties: properties)
                try await self.updateName(withName:self.name?
                    .trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
        }
    }
    
    private func updateName(withName name: String?) async {
        if let name = name {
            await SupabaseManager.shared.setUserName(name: name) { isSaved in
                if isSaved {
                    DispatchQueue.main.async {
                        let secondQuesVC = SecondQuestionViewControllerFactory.produce(withName: name)
                        self.navigationController?.pushViewController(secondQuesVC, animated: true)
                    }
                } else {
                    print("error in logging in")
                }
            }
        }
    }
    
    func checkToEnableCTA(withLength length: Int) {
        if length >= 0 {
            enableCta()
        } else {
            disableCTA()
        }
    }
    
    func enableCta() {
        cta.isUserInteractionEnabled = true
        let config = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                  withBackgroundColor: Colors.white_E5E5E5.value,
                                  withImage: UIImage(named: "arrowForward"),
                                  isImageInRight: true)
        cta.render(withConfig: config, withText: "Next ")
    }
    
    func disableCTA() {
        cta.isUserInteractionEnabled = false
        let config = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                  withBackgroundColor: Colors.white_E5E5E5.value.withAlphaComponent(0.5),
                                  withImage: UIImage(named: "arrowForward"),
                                  isImageInRight: true)
        cta.render(withConfig: config, withText: "Next ")
    }
}
extension FirstQuestionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length

        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            self.name = txtAfterUpdate
        }
        
        checkToEnableCTA(withLength: newLength)
        return true
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
