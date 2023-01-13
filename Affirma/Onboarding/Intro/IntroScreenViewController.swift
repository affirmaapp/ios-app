//
//  IntroScreenViewController.swift
//  Affirma
//
//  Created by Airblack on 11/01/23.
//

import Foundation
import UIKit

class IntroScreenViewControllerFactory: NSObject {
    class func produce() -> IntroScreenViewController {
        let introVC = IntroScreenViewController(nibName: "IntroScreenViewController",
                                                bundle: nil)
        return introVC
    }
}

class IntroScreenViewController: BaseViewController {
    @IBOutlet weak private var gradientView: UIView!
    @IBOutlet weak private var mediaView: GenericMediaView!
    @IBOutlet weak private var subtitleText: UILabel!
    @IBOutlet weak private var genericButton: GenericButtonView!
    @IBOutlet weak private var firstText: UILabel!
    @IBOutlet weak private var thirdText: UILabel!
    @IBOutlet weak private var secondText: UILabel!
    @IBOutlet weak private var titleText: UILabel!
    @IBOutlet weak private var fourthText: UILabel!
    
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
                         withGif: "sixthStep")
        
        UIView.animate(withDuration: 0.5, delay: 1) {
            self.titleText.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.subtitleText.alpha = 1.0
            } completion: { _ in
                self.animateText()
            }
        }
        
        genericButton.isUserInteractionEnabled = false
        genericButton.render(withType: .inactive, withText: "Let's do this!")
    }
    
    func animateText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.firstText.setTextWithTypeAnimation(typedText: "chronically sarcastic 💛")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.secondText.setTextWithTypeAnimation(typedText: "snarky and sassy 💚")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            self.thirdText.setTextWithTypeAnimation(typedText: "stubbornly skeptical 💜")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            
            self.fourthText.setTextWithTypeAnimation(typedText: "affirmation additcts 🫶")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            
            self.enableCTA()
        }
        
    }
    
    func enableCTA() {
        genericButton.isUserInteractionEnabled = true
        genericButton.render(withType: .primaryCta, withText: "Let's do this!")
    }
    
    private func handleTap() {
        genericButton.primaryCtaClicked = {
            let lastStepVC = LastStepViewControllerFactory.produce()
            self.navigationController?.pushViewController(lastStepVC, animated: true)
        }
    }
}
