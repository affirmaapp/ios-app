//
//  ButtonConfig.swift
//  Affirma
//
//  Created by Airblack on 30/12/22.
//

import Foundation
import UIKit

class ButtonConfig: NSObject {
    var textColor: UIColor?
    var font: UIFont?
    var backgroundColor: UIColor?
    var borderColor: UIColor?
    var image: UIImage?
    var isUserInteractionEnabled: Bool?
    var corderRadius: CGFloat?
    var isImageInRight: Bool?
    
    init(withTextColor textColor: UIColor?,
         withFont font: UIFont? = Font(.installed(.avenirLight),
                                       size: .standard(.header3)).instance,
         withBackgroundColor backgroundColor: UIColor?,
         withBorderColor borderColor: UIColor? = .clear,
         withImage image: UIImage? = nil,
         isUserInteractionEnabled: Bool? = true,
         withCornerRadius cornerRadius: CGFloat? = 27.0,
         isImageInRight: Bool = false) {
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.image = image
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.corderRadius = cornerRadius
        self.isImageInRight = isImageInRight
    }
}
