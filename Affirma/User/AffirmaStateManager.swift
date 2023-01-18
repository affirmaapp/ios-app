//
//  AffirmaStateManager.swift
//  Affirma
//
//  Created by Airblack on 15/01/23.
//

import Foundation


class AffirmaStateManager: NSObject {
    @objc static let shared = AffirmaStateManager()
    
    var activeUser: AffirmaUser? {
        didSet {
            saveActiveUser()
        }
    }
    
    func saveActiveUser() {
        do {
            if let loggedInUser = activeUser {
                let data = try NSKeyedArchiver.archivedData(
                    withRootObject: loggedInUser,
                    requiringSecureCoding: false
                )
                UserDefaults.standard.set(data, forKey: "loggedInUser")
                UserDefaults.standard.synchronize()
            }
        } catch {
            print(error)
            print("Couldn't save user object")
        }
    }
    
    func fetchLoggedInUser() {
        if let data = UserDefaults.standard.data(forKey: "loggedInUser") {
            do {
                if let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AffirmaUser {
                    activeUser = user
                }
            } catch {
                print("Couldn't fetch user object")
            }
        }
    }
    
    func login(withUser user: AffirmaUser) {
        activeUser = user
//        if let accessToken = user.token {
//            NetworkManager.shared.setAuthorizationHeader(withToken: accessToken)
//        }
    }
    
    func logout() {
        activeUser = nil
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

