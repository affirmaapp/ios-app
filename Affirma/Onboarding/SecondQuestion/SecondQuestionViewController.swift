//
//  SecondQuestionViewController.swift
//  Affirma
//
//  Created by Airblack on 11/01/23.
//

import Foundation
import UIKit

class SecondQuestionViewControllerFactory: NSObject {
    class func produce(withName name: String?) -> SecondQuestionViewController {
        let secondQuesVC = SecondQuestionViewController(nibName: "SecondQuestionViewController",
                                                       bundle: nil)
        secondQuesVC.name = name
        return secondQuesVC
    }
}

class SecondQuestionViewController: BaseViewController {
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backButton: GenericButtonView!
    @IBOutlet weak var forwardButton: GenericButtonView!
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    fileprivate var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        handleTap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
        
    }
    
    private func setUI() {
        
        greetingText.setTextWithTypeAnimation(typedText: "Awesome \(name ?? ""),\nYou're almost there!")
        mediaView.render(withImage: nil,
                         withVideo: nil,
                         withGif: "fifthStep")
        
        let config = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                  withBackgroundColor: Colors.white_E5E5E5.value,
                                  withImage: UIImage(named: "arrowForward"),
                                  isImageInRight: true)
        forwardButton.render(withConfig: config, withText: "Next ", withTag: 0)
        
        
        let backButtonConfig = ButtonConfig(withTextColor: Colors.white_E5E5E5.value,
                                  withBackgroundColor: .clear,
                                  withImage: UIImage(named: "backButton"))
        backButton.render(withConfig: backButtonConfig, withText: "Back ", withTag: 1)
        
        Task {
            try await self.updateTest()
        }
    }
    
    private func updateTest() async {
    }
    
    private func handleTap() {
        forwardButton.customCtaCtaClicked = { tag in
            let introScreenVC = IntroScreenViewControllerFactory.produce()
            self.navigationController?.pushViewController(introScreenVC, animated: true)
        }
        
        backButton.customCtaCtaClicked = { tag in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
