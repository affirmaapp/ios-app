//
//  ChoicesOverPopup.swift
//  Affirma
//
//  Created by Airblack on 22/01/23.
//

import Foundation
import UIKit

class ChoicesOverPopup: UIView {
    
    @IBOutlet var choiceOverPopup: UIView!
    @IBOutlet weak var heartIcon: UIImageView!
    
    var popupDismissed: (() -> Void)?
    
    @IBAction func closePressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            self.popupDismissed?()
        }
    }
    
}
