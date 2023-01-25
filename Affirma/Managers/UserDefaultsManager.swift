//
//  UserDefaultsManager.swift
//  Affirma
//
//  Created by Airblack on 24/01/23.
//

import Foundation

class UserDefaultsManager: NSObject {
    
    @objc static let shared = UserDefaultsManager()
    
    var deeplink: String {
        get {
           return getDefault(key: "deeplink") as? String ?? ""
        }
        set {
            setDefault(value: newValue, key: "deeplink")
        }
    }
    
    private func setDefault(value: Any, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    private func getDefault(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
}
