//
//  LastStepViewController.swift
//  Affirma
//
//  Created by Airblack on 13/01/23.
//

import Foundation
import UIKit

class LastStepViewControllerFactory: NSObject {
    class func produce() -> LastStepViewController {
        let lastStepVC = LastStepViewController(nibName: "LastStepViewController",
                                                bundle: nil)
        return lastStepVC
    }
}

class LastStepViewController: BaseViewController {
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var cta: GenericButtonView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        handleTap()
        
        EventManager.shared.trackEvent(event: .landedOnLastStep)
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
                         withGif: "lastStep")
        
        UIView.animate(withDuration: 0.5, delay: 1) {
            self.label.alpha = 1.0
        }
        cta.render(withType: .primaryCta, withText: "Let's do this!")
    }
    
    private func handleTap() {
        cta.primaryCtaClicked = {
            
            let properties: [String: Any] = ["screen": "Last Step Screen"]
            EventManager.shared.trackEvent(event: .ctaTapped,
                                           properties: properties)
            
            let homeVC = HomeViewControllerFactory.produce()
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
}
