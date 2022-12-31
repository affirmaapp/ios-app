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
    
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cta: GenericButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        subtextLabel.setTextWithTypeAnimation(typedText: "It’s about time you showed up!")
        
        cta.render(withType: .primaryCta, withText: "Continue")

        mediaView.render(withImage: nil,
                         withVideo: nil,
                         withGif: "secondStep")
    }
    
    private func handleTap() {
        cta.primaryCtaClicked = {
            
        }
    }
}
