//
//  GradientView.swift
//  Affirma
//
//  Created by Airblack on 01/01/23.
//

import Foundation
import UIKit

// MARK: Protocol

class GradientView: UIView {
    // MARK: Outlets
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    // MARK: Properties
    
    // MARK: Lifecycle Functions
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    // MARK: Setting Up UI
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map { $0.cgColor }
        if isHorizontal {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
    
    // MARK: Actions
}

// MARK: Helper Functions

