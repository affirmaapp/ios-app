//
//  SendLoveViewController.swift
//  Affirma
//
//  Created by Airblack on 20/01/23.
//

import Foundation
import UIKit

class SendLoveViewController: BaseViewController {
    @IBOutlet var gradientView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    @IBAction func logoutClicked(_ sender: Any) {
//        Task {
//            _ = try? await SupabaseManager.shared.logout()
//            
//            DispatchQueue.main.async {
//                let loginVC = LoginViewControllerFactory.produce()
//                let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
//                let nav = UINavigationController(rootViewController: loginVC)
//                nav.isNavigationBarHidden = true
//                appDelegate.window?.rootViewController = nav
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
}
