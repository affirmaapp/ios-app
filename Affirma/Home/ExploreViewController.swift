//
//  ExploreViewController.swift
//  Affirma
//
//  Created by Airblack on 19/01/23.
//

import Foundation
import UIKit

class ExploreViewController: BaseViewController {
    
    @IBAction func logoutClicked(_ sender: Any) {
        Task {
            _ = try? await SupabaseManager.shared.logout()
            
            DispatchQueue.main.async {
                let loginVC = LoginViewControllerFactory.produce()
                let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                let nav = UINavigationController(rootViewController: loginVC)
                nav.isNavigationBarHidden = true
                appDelegate.window?.rootViewController = nav
            }
        }
    }
}
