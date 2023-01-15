//
//  LoginViewController.swift
//  Affirma
//
//  Created by Airblack on 29/12/22.
//

import Foundation
import UIKit

class LoginViewControllerFactory: NSObject {
    
    class func produce() -> LoginViewController {
        let loginVC = LoginViewController(nibName: "LoginViewController",
                                          bundle: nil)
        return loginVC
    }
}

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cta: GenericButtonView!
    
    fileprivate var number: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        handleTap()
        textField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
        
    }
    
    private func setUI() {
        subtextLabel.setTextWithTypeAnimation(typedText: "It’s about time you showed up!")
        
        cta.isUserInteractionEnabled = false
        cta.render(withType: .inactive, withText: "Continue")
        
        mediaView.render(withImage: nil,
                         withVideo: nil,
                         withGif: "secondStep")
        
        textField.attributedPlaceholder = Utility
            .getAttributedString(font: Font(.installed(.avenirLight),
                                            size: .custom(24.0)).instance,
                                 color: Colors.white_E5E5E5.withAlpha(0.5),
                                 text: "+91 0123456789")
        
    }
    
    private func handleTap() {
 
        cta.primaryCtaClicked = {
            Task {
                try await self.signIn()
            }
            let otpVC = OTPViewControllerFactory.produce(withNumber: self.number)
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    
    private func signIn() async {
        if let number = self.number {
            await SupabaseManager.shared.signIn(withNumber: number)
        }
    }
    
    
    
    func enableCta() {
        cta.isUserInteractionEnabled = true
        cta.render(withType: .primaryCta, withText: "Continue")
    }
    
    func disableCTA() {
        cta.isUserInteractionEnabled = false
        cta.render(withType: .inactive, withText: "Continue")
    }
    
    func checkToEnableCTA(withLength length: Int) {
        if length >= 10 {
            enableCta()
        } else {
            disableCTA()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
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
            self.number = txtAfterUpdate
        }
        
        checkToEnableCTA(withLength: newLength)
        return newLength <= 20
    }
}
