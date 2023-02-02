//
//  GenericLoader.swift
//  Affirma
//
//  Created by Airblack on 02/02/23.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class GenericLoader: UIView {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet var genericLoader: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GenericLoader", owner: self, options: nil)
        addSubview(genericLoader)
        genericLoader.frame = self.bounds
        setUI()
    }
    
    func render(withState isLoading: Bool?) {
        if let isLoading = isLoading, isLoading == true {
            startAnimating()
        } else {
            stopAnimating()
        }
        activityIndicator.color = Colors.purple_7D5FFF.withAlpha(0.5)
        
    }
    
    func setUI() {
        activityIndicator.type = .orbit
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
