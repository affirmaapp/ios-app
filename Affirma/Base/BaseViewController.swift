//
//  BaseViewController.swift
//  Affirma
//
//  Created by Airblack on 26/12/22.
//

import Anchorage
import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var keyboardHideTapGesture: UITapGestureRecognizer?
    private let loaderView = UIView()
    private let loader: GenericLoader = GenericLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedOrSwiped()
        
        loaderView.backgroundColor = Colors.black_18181C.value.withAlphaComponent(0.5)
        loader.render(withState: false)
        loaderView.addSubview(loader)
        loader.heightAnchor == 150.0
        loader.widthAnchor == 150.0
        loader.centerXAnchor == loaderView.centerXAnchor
        loader.centerYAnchor == loaderView.centerYAnchor
    }
    
    func showFullScreenLoader() {
        DispatchQueue.main.async {
            self.loader.startAnimating()
            self.view.addSubview(self.loaderView)
            self.loaderView.horizontalAnchors == self.view.horizontalAnchors
            self.loaderView.verticalAnchors == self.view.verticalAnchors
            self.view.bringSubviewToFront(self.loaderView)
        }
    }
    
    func hideFullScreenLoader() {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.loaderView.removeFromSuperview()
        }
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
