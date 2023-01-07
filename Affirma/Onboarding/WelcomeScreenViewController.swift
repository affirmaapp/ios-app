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
                let newViewController = LoginViewControllerFactory.produce()
                let navigation = UINavigationController(rootViewController: newViewController)
                navigation.isNavigationBarHidden = true
                navigation.isModalInPresentation = true
                navigation.interactivePopGestureRecognizer?.isEnabled = true
                navigation.interactivePopGestureRecognizer?.delegate = nil 
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: true)
            default:
                break
            }
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
