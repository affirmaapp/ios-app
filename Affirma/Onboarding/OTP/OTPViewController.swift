//
//  OTPViewController.swift
//  Affirma
//
//  Created by Airblack on 01/01/23.
//

import Foundation
import OTPFieldView
import UIKit

class OTPViewControllerFactory: NSObject {
    class func produce(withNumber number: String?) -> OTPViewController {
        let otpVC = OTPViewController(nibName: "OTPViewController",
                                      bundle: nil)
        otpVC.number = number
        return otpVC
    }
}

class OTPViewController: BaseViewController {
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var otpView: OTPFieldView!
    @IBOutlet weak var cta: GenericButtonView!
    
    fileprivate var number: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        handleTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.otpView.initializeUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
        
    }
    
    private func setUI() {
        self.otpView.fieldsCount = 4
        self.otpView.fieldBorderWidth = 2
        self.otpView.defaultBorderColor = Colors.white_E5E5E5.value
        self.otpView.filledBorderColor = Colors.white_E5E5E5.value
        self.otpView.fieldTextColor = Colors.white_E5E5E5.value

        self.otpView.cursorColor = Colors.white_E5E5E5.value
        self.otpView.displayType = .underlinedBottom
        self.otpView.fieldSize = 40
        self.otpView.otpInputType = .numeric
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.tintColor = Colors.white_E5E5E5.value
//        self.otpView.errorBorderColor = Colors.abRed.value
        self.otpView.delegate = self
        
        
        mediaView.render(withImage: nil,
                         withVideo: nil,
                         withGif: "thirdStep")
        
        cta.render(withType: .primaryCta, withText: "Let's roll")
    }
    
    private func handleTap() {
        cta.primaryCtaClicked = {
            let firstQuesVC = FirstQuestionViewControllerFactory.produce()
            let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
            let nav = UINavigationController(rootViewController: firstQuesVC)
            nav.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = nav
        }
    }
}


extension OTPViewController: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        
        return true
    }
    
    func enteredOTP(otp: String) {
        
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        if hasEnteredAll == true {
            // verify
        } else {
            // disable button
        }
        return false
    }
}
