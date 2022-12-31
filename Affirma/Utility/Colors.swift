//
//  Colors.swift
//  Affirma
//
//  Created by Airblack on 26/12/22.
//

import Foundation
import UIKit

enum Colors {
    case black_2E302F
    case black_131415
    case white_E5E5E5
    case black_1A1B1C
    case custom(hexString: String, alpha: Double)
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

enum ColorStrings: String {
    case black_2E302F = "Black_2E302F"
    case black_131415 = "Black_131415"
    case white_E5E5E5 = "White_E5E5E5"
    case black_1A1B1C = "Black_1A1B1C"
}

extension Colors {
    
    var value: UIColor {
        var color = UIColor.clear
        
        switch self {
        case .black_131415:
            color = UIColor(named: ColorStrings.black_131415.rawValue) ?? .white
        case .black_2E302F:
            color = UIColor(named: ColorStrings.black_2E302F.rawValue) ?? .white
        case .white_E5E5E5:
            color = UIColor(named: ColorStrings.white_E5E5E5.rawValue) ?? .white
        case .black_1A1B1C:
            color = UIColor(named: ColorStrings.black_1A1B1C.rawValue) ?? .white
        case let .custom(hexValue, opacity):
            color = hexStringToUIColor(hex: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return color
    }
    
    static func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 60, height: 60)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        if let context = context {
            context.setFillColor(color.cgColor)
            context.fill(rect)

            let image = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()

            return image
        }
        return nil
    }
    
    func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return Colors.black_131415.value
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hexString: Int) {
       self.init(
           red: (hexString >> 16) & 0xFF,
           green: (hexString >> 8) & 0xFF,
           blue: hexString & 0xFF
       )
   }
}
