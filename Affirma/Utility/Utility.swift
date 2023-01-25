//
//  Utility.swift
//  Affirma
//
//  Created by Airblack on 30/12/22.
//

import Foundation
import UIKit

class Utility {
    
    static func getConfigFor(forType type: ButtonType?) -> ButtonConfig? {
        var buttonConfig: ButtonConfig?
        
        if let type = type {
            switch type {
            case .primaryCta:
                buttonConfig = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                            withBackgroundColor: Colors.white_E5E5E5.value)
            case .secondaryCta:
                buttonConfig = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                            withBackgroundColor: Colors.white_E5E5E5.value)
            case .onlyText:
                buttonConfig = ButtonConfig(withTextColor: Colors.white_E5E5E5.value,
                                            withBackgroundColor: .clear)
            case .inactive:
                buttonConfig = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                            withBackgroundColor: Colors.white_E5E5E5.withAlpha(0.5))
            case .custom:
                return nil
            }
        }
        return buttonConfig
    }
    
    typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

    enum GradientOrientation {
        case topRightBottomLeft
        case topLeftBottomRight
        case horizontal
        case vertical
        
        var startPoint: CGPoint {
            return points.startPoint
        }
        
        var endPoint: CGPoint {
            return points.endPoint
        }
        
        var points: GradientPoints {
            get {
                switch self {
                case .topRightBottomLeft:
                    return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
                case .topLeftBottomRight:
                    return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
                case .horizontal:
                    return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
                case .vertical:
                    return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
                }
            }
        }
    }
    
    static func getAttributedString(font: UIFont,
                             color: UIColor,
                             text: String) -> NSAttributedString {
        let myString = text
        let myAttribute = [ NSAttributedString.Key.foregroundColor: color,
                            NSAttributedString.Key.font: font]
        
        let attibutedString = NSAttributedString(string: myString, attributes: myAttribute)

        // set attributed text on a UILabel
        return attibutedString
    }
    
    class func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else {
            return nil
        }
        return url.queryItems?.first { $0.name == param }?.value
    }
}
