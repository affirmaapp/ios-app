//
//  WelcomeScreenViewController.swift
//  Affirma
//
//  Created by Airblack on 26/12/22.
//

import Foundation
import UIKit

class WelcomeScreenViewControllerFactory: NSObject {
    class func produce() -> WelcomeScreenViewController {
        let welcomeVC = WelcomeScreenViewController(nibName: "WelcomeScreenViewController",
                                                    bundle: nil)
        return welcomeVC
    }
}

class WelcomeScreenViewController: BaseViewController {
    @IBOutlet private weak var subtextLabel: UILabel!
    @IBOutlet private weak var arrowDownImage: UIImageView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            _ = try? await SupabaseManager.shared.fetchUser(completion: { _ in
                
            })
            
        }
        
        AffirmaStateManager.shared.fetchLoggedInUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
            self.view.addGestureRecognizer(swipeUp)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
        
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up:
                //right view controller
                self.checkAndOpen()
            default:
                break
            }
        }
    }
    
    private func checkAndOpen() {
        // if a user is not present - open login
        // if a user is present and state is PRE_OB - take them to name
        // if state is active - take them to home
        Task {
            _ = try? await SupabaseManager.shared.isUserPresent(completion: { isUserLoggedIn in
                if isUserLoggedIn {
                    if AffirmaStateManager.shared.activeUser != nil {
                        if let state = AffirmaStateManager.shared.activeUser?.metaData?.state ,
                           state == "ACTIVE" {
                            DispatchQueue.main.async {
                                let newViewController = HomeViewControllerFactory.produce()
                                let navigation = UINavigationController(rootViewController: newViewController)
                                navigation.isNavigationBarHidden = true
                                navigation.isModalInPresentation = true
                                navigation.interactivePopGestureRecognizer?.isEnabled = true
                                navigation.interactivePopGestureRecognizer?.delegate = nil
                                navigation.modalPresentationStyle = .fullScreen
                                self.present(navigation, animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                let newViewController = FirstQuestionViewControllerFactory.produce()
                                let navigation = UINavigationController(rootViewController: newViewController)
                                navigation.isNavigationBarHidden = true
                                navigation.isModalInPresentation = true
                                navigation.interactivePopGestureRecognizer?.isEnabled = true
                                navigation.interactivePopGestureRecognizer?.delegate = nil
                                navigation.modalPresentationStyle = .fullScreen
                                self.present(navigation, animated: true)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            let newViewController = LoginViewControllerFactory.produce()
                            let navigation = UINavigationController(rootViewController: newViewController)
                            navigation.isNavigationBarHidden = true
                            navigation.isModalInPresentation = true
                            navigation.interactivePopGestureRecognizer?.isEnabled = true
                            navigation.interactivePopGestureRecognizer?.delegate = nil
                            navigation.modalPresentationStyle = .fullScreen
                            self.present(navigation, animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let newViewController = LoginViewControllerFactory.produce()
                        let navigation = UINavigationController(rootViewController: newViewController)
                        navigation.isNavigationBarHidden = true
                        navigation.isModalInPresentation = true
                        navigation.interactivePopGestureRecognizer?.isEnabled = true
                        navigation.interactivePopGestureRecognizer?.delegate = nil
                        navigation.modalPresentationStyle = .fullScreen
                        self.present(navigation, animated: true)
                    }
                }
            })
        }

        
    }
    
    private func setUI() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.subtextLabel.alpha = 1
        }
        
        mediaView.render(withImage: nil, withVideo: nil, withGif: "logoGif")
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear, .repeat, .autoreverse]) {
            
            self.arrowDownImage.frame = self.arrowDownImage.frame.insetBy(dx: 2, dy: 2)
            
        }
    }
}
