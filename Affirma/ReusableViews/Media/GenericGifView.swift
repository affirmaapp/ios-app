//
//  GenericGifView.swift
//  Affirma
//
//  Created by Airblack on 28/12/22.
//

import Foundation
import Gifu
import UIKit


class GenericGifView: UIView {
    
    @IBOutlet var genericGifView: UIView!
    @IBOutlet weak var gifImageView: GIFImageView!
    
    // MARK: Lifecycle Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GenericGifView", owner: self, options: nil)
        addSubview(genericGifView)
        genericGifView.frame = self.bounds
    }
    
    func render(withGifUrl gifUrl: String?,
                isLoop: Bool?) {
        guard let gifUrl = gifUrl else {
            return
        }
        gifImageView.animate(withGIFNamed: gifUrl)
    }
    
}
