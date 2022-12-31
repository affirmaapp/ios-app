//
//  Utility.swift
//  Affirma
//
//  Created by Airblack on 30/12/22.
//

import Foundation

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
                                            withBackgroundColor: Colors.white_E5E5E5.value)
            case .custom:
                return nil
            }
        }
        return buttonConfig
    }
}
