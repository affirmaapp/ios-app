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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()

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
