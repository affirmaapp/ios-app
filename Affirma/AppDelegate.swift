//
//  AppDelegate.swift
//  Affirma
//
//  Created by Airblack on 26/12/22.
//

import Branch
import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.white_CAD0DE.value], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.black_1A1B1C.value], for: .selected)
        UITabBar.appearance().tintColor = Colors.black_1A1B1C.value
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        // TODO: REMOVE FOR PROD
        Branch.setUseTestBranchKey(true)
          
        
        let branch: Branch = Branch.getInstance()
        branch.enableLogging()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
         if error == nil {
             print(params as? [String: AnyObject] ?? {})
             if let userInfo = params as? [String: Any] {
                 let deeplink = userInfo["$deeplink_path"] as? String
                 DeeplinkManager.shared.handle(deeplink: deeplink, shouldPresent: false)
             }
         print("params: %@", params as? [String: AnyObject] ?? {})
         }
       })
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Branch.getInstance().application(app, open: url, options: options)
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return Branch.getInstance().continue(userActivity)
    }
}

