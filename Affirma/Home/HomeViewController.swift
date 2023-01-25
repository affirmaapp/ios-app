//
//  HomeViewController.swift
//  Affirma
//
//  Created by Airblack on 18/01/23.
//

import Foundation
import UIKit

class HomeViewControllerFactory: NSObject {
    class func produce() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let homeVC =
                storyboard
                .instantiateViewController(withIdentifier: "HomeViewController")
                as? HomeViewController else {
            fatalError("homeVC failed while casting")
        }
        return homeVC
    }
}

class HomeViewController: UITabBarController {
    
    var upperLineView: UIView!
    
    let spacing: CGFloat = 12
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.selectMessagesRecieved(notification:)),
                                               name: AffirmaNotification.switchToMessagesRecieved,
                                               object: nil)
    }
    
    @objc
    func selectMessagesRecieved(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectedIndex = 2
        }
    }
    
    func addTabbarIndicatorView(index: Int, isFirstTime: Bool = false){
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        if !isFirstTime{
            upperLineView.removeFromSuperview()
        }
        upperLineView = UIView(frame: CGRect(x: tabView.frame.minX + spacing,
                                             y: tabView.frame.minY + 0.1,
                                             width: tabView.frame.size.width - spacing * 2,
                                             height: 2))
        upperLineView.backgroundColor = Colors.black_131415.value
        tabBar.addSubview(upperLineView)
    }
    
}

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        addTabbarIndicatorView(index: self.selectedIndex)
    }
}
