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
        
        UNUserNotificationCenter.current().delegate = self
        
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
                 if let props = userInfo["$custom_meta_tags"] as? String {
                     print("PROPS JSON: \(props.toJSON())")
                     let data = props.data(using: .utf8)!
                     do {
                         if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any]
                         {
                            print(jsonArray) // use the json here
                             if let metaTags = jsonArray as? [String: Any] {
                                 
                                 let senderId = metaTags["sender_id"] as? String
                                 let cardId = metaTags["card_id"] as? String
                                 let affirmation = metaTags["affirmation"] as? String
                                 let affirmationImage = metaTags["affirmation_image"] as? String
                                 let senderName = metaTags["sender_name"] as? String
                                 let message_id = metaTags["message_id"] as? String
                                 let dataModel = ReceivedMessagesDataModel(withSenderId: senderId,
                                                                           withCardId: cardId,
                                                                           withAffirmation: affirmation,
                                                                           withAffirmationImage: affirmationImage,
                                                                           withSenderName: senderName,
                                                                           withMessageId: message_id)
                                 
                                 let baseModel = ReceivedMessagesBaseModel(withData: [dataModel])
                                 AffirmaStateManager.shared.deeplinkToExecute = deeplink
                                 AffirmaStateManager.shared.messageToAdd = baseModel
                             }
                         } else {
                             print("bad json")
                         }
                     } catch let error as NSError {
                         print(error)
                     }
                 }
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


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let notification = response.notification.request.content.userInfo as? [String: Any] {
            if let affirmation = notification["affirmation"] as? String,
               let affirmation_image = notification["affirmation_image"] as? String {
                NotificationManager.shared.affirmationText = affirmation
                NotificationManager.shared.affirmationImage = affirmation_image
                
                NotificationCenter.default.post(name: AffirmaNotification.reloadExplore,
                                                object: nil,
                                                userInfo: nil)
            }
        }
    }
}
