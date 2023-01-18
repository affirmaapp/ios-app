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
    fileprivate var otp: String?
    
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
        self.otpView.fieldsCount = 6
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
        
    }
    
    private func verifyOTP(withNumber number: String?, otp: String?) async {
        if let number = number,
           let otp = otp {
            await SupabaseManager.shared.verify(withPhoneNumber: number,
                                                witToken: otp) { isVerified in
                if isVerified {
                    DispatchQueue.main.async {
                        SupabaseManager.shared.isUserActive(completion: { isOnboardingComplete in
                            if isOnboardingComplete {
                                let homeVC = HomeViewControllerFactory.produce()
                                let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                                let nav = UINavigationController(rootViewController: homeVC)
                                nav.isNavigationBarHidden = true
                                appDelegate.window?.rootViewController = nav
                            } else {
                                let firstQuesVC = FirstQuestionViewControllerFactory.produce()
                                let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                                let nav = UINavigationController(rootViewController: firstQuesVC)
                                nav.isNavigationBarHidden = true
                                appDelegate.window?.rootViewController = nav
                            }
                        })
                    }
                } else {
                    print("error in logging in")
                }
            }
        }
    }
    
    
    private func enableCTA() {
        self.cta.isUserInteractionEnabled = true
        cta.render(withType: .primaryCta, withText: "Let's roll")
    }
    
    private func disableCTA() {
        self.cta.isUserInteractionEnabled = false
        cta.render(withType: .inactive, withText: "Let's roll")
    }
    
    private func handleTap() {
        cta.primaryCtaClicked = {
            Task {
                try await self.verifyOTP(withNumber: self.number,
                                         otp: self.otp)
            }
        }
    }
}


extension OTPViewController: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        
        return true
    }
    
    func enteredOTP(otp: String) {
        self.otp = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        
        if hasEnteredAll == true {
            self.enableCTA()
        } else {
            self.disableCTA()
        }
        return false
    }
}
