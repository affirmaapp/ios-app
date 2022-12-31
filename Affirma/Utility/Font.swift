//
//  Font.swift
//  Affirma
//
//  Created by Airblack on 30/12/22.
//

import Foundation

import Foundation
import UIKit

struct Font {
    let errorMessage = """
    Font is not installed, make sure it added in Info.plist
    and logged with Utility.logAllAvailableFonts()
    """

    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    enum FontName: String {
        case avenirLight       = "Avenir-Light"
        case avenirMedium      = "Avenir-Medium"
        case avenirHeavy       = "Avenir-Heavy"
        case avenirBook        = "Avenir-Book"
    }
    
    enum StandardSize: Double {
        case header1 = 20.0
        case header2 = 18.0
        case header3 = 16.0
        case header4 = 14.0
        case header5 = 12.0
        case header6 = 10.0
    }

    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font = UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) \(self.errorMessage)")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font = UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) \(self.errorMessage)")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        }
        return instanceFont
    }
}
