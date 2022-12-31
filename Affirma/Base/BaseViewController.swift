//
//  BaseViewController.swift
//  Affirma
//
//  Created by Airblack on 26/12/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var keyboardHideTapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedOrSwiped()
    }
    func hideKeyboardWhenTappedOrSwiped() {
        keyboardHideTapGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(BaseViewController.dismissKeyboard))
        keyboardHideTapGesture?.cancelsTouchesInView = false
        if let keyboardHideTapGesture = keyboardHideTapGesture {
            view.addGestureRecognizer(keyboardHideTapGesture)
        }
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(BaseViewController.dismissKeyboard))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
