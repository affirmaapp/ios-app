//
//  GenericButtonView.swift
//  Affirma
//
//  Created by Airblack on 30/12/22.
//

import Foundation
import UIKit

public enum ButtonType {
    case primaryCta
    case secondaryCta
    case onlyText
    case inactive
    case custom
}

class GenericButtonView: UIView {
    
    @IBOutlet private var genericButtonView: UIView!
    @IBOutlet private weak var cta: UIButton!
    
    var type: ButtonType = .primaryCta
    
    var primaryCtaClicked: (() -> Void)?
    var secondayCtaClicked: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GenericButtonView", owner: self, options: nil)
        addSubview(genericButtonView)
        genericButtonView.frame = self.bounds
    }
    
    func render(withType type: ButtonType,
                withText text: String?) {
        self.type = type
        self.setButtonUI(withConfig: Utility.getConfigFor(forType: type),
                         withText: text)
    }
    
    func render(withConfig config: ButtonConfig?,
                withText text: String?) {
        self.type = .custom
        self.setButtonUI(withConfig: config, withText: text)
    }
    
    private func setButtonUI(withConfig config: ButtonConfig?,
                             withText text: String?) {
        var text: String = text ?? ""
        self.cta.isUserInteractionEnabled = config?.isUserInteractionEnabled ?? true
        self.cta.backgroundColor = config?.backgroundColor
        self.cta.layer.borderColor = config?.borderColor?.cgColor
        self.cta.setTitleColor(config?.textColor,
                                  for: .normal)
        self.cta.titleLabel?.font = config?.font
        self.cta.layer.borderWidth = 1
        self.cta.cornerRadius = config?.corderRadius ?? 4.0
        if let isImageInRight = config?.isImageInRight,
           isImageInRight == true {
            self.cta.semanticContentAttribute = .forceRightToLeft
        } else {
            self.cta.semanticContentAttribute = .forceLeftToRight
        }
       
        if let image = config?.image {
            text = "  " + text
            self.cta.setImage(image, for: .normal)
        } else {
            self.cta.setImage(nil, for: .normal)
        }
        
        self.cta.setTitle(text, for: .normal)
    }
    
    @IBAction func ctaClicked(_ sender: Any) {
        switch type {
        case .primaryCta:
            self.primaryCtaClicked?()
        case .secondaryCta:
            self.secondayCtaClicked?()
        case .onlyText:
            print("")
        case .inactive:
            print("")
        case .custom:
            print("")
        }
    }
    
}
