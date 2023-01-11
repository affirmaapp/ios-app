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
        
        mediaView.render(withImage: nil,
                         withVideo: nil,
                         withGif: "fourthStep")
        
        nameTextField.attributedPlaceholder = Utility
            .getAttributedString(font: Font(.installed(.avenirLight),
                                            size: .custom(24.0)).instance,
                                 color: Colors.white_E5E5E5.withAlpha(0.5),
                                 text: "John")
        
        let config = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                  withBackgroundColor: Colors.white_E5E5E5.value,
                                  withImage: UIImage(named: "arrowForward"),
                                  isImageInRight: true)
        cta.render(withConfig: config, withText: "Next ")
    }
    
    private func handleTap() {
        cta.customCtaCtaClicked = { tag in
            let secondQuesVC = SecondQuestionViewControllerFactory.produce(withName: "Vidushi")
            self.navigationController?.pushViewController(secondQuesVC, animated: true)
        }
    }
}
