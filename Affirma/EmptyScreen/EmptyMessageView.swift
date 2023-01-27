//
//  EmptyMessageView.swift
//  Affirma
//
//  Created by Airblack on 26/01/23.
//

import Foundation
import UIKit


class EmptyMessageView: UIView {
    
    @IBOutlet var emptyMessageView: UIView!
    
    var sendLoveClicked: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EmptyMessageView", owner: self, options: nil)
        addSubview(emptyMessageView)
        emptyMessageView.frame = self.bounds
    }
    
    @IBAction func sendLoveClicked(_ sender: Any) {
        self.sendLoveClicked?() 
    }
}
