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
    @IBOutlet weak private var animatableText: UILabel!
    @IBOutlet weak private var titleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animatableText.setTextWithTypeAnimation(typedText: "chronically sarastic")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            self.animatableText.setTextWithTypeAnimation(typedText: "snarky and sassy")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            
            self.animatableText.setTextWithTypeAnimation(typedText: "stubbornly skeptical")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            
            self.animatableText.setTextWithTypeAnimation(typedText: "affirmation additcts 🫶")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            
            self.enableCTA()
        }
        
    }
    
    func enableCTA() {
        genericButton.isUserInteractionEnabled = true
        genericButton.render(withType: .primaryCta, withText: "Let's do this!")
    }
}
