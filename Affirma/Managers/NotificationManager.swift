//
//  NotificationManager.swift
//  Affirma
//
//  Created by Airblack on 30/01/23.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
    
    @objc static let shared = NotificationManager()
    let exploreManager = ExploreManager()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var affirmationImagesList: [AffirmationImage] = []
    var affirmationTextList: [AffirmationText] = []
    
    var affirmationImage: String?
    var affirmationText: String?
    
    override init() {
        super.init()
        self.userNotificationCenter.delegate = self

    }
    
//    init() {
//        self.exploreManager = ExploreManager()
//    }
    
    func requestNotificationAuthorization() {
        // Code here
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
        
    }
    
    
    func fetchImageList() async {
        await exploreManager.fetchAffirmationImages(completion: { imagesList in
            NotificationManager.shared.affirmationImagesList = imagesList
            print("LIST: \(imagesList.count)")
            
        })
    }
    
    func fetchTextList() async {
        await exploreManager.fetchAffirmationText(completion: { textList in
            NotificationManager.shared.affirmationTextList = textList
            
            print("TEXT LIST: \(textList.count)")
            
        })
    }
    
    func fetchNotificationData() {
        Task {
            let _ = try? await fetchImageList()
            let _ = try? await fetchTextList()
        }
    }

    func sendNotification() {
        
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        let body = NotificationManager.shared.affirmationTextList.randomElement()?.text ?? ""
        let image = NotificationManager.shared.affirmationImagesList.randomElement()?.image_url ?? ""
        
        notificationContent.title = "Affirma"
        notificationContent.body = body
        //            notificationContent.badge = NSNumber(value: 3)
        notificationContent.userInfo = ["affirmation": body,
                                        "affirmation_image": image]
        
        // Add an attachment to the notification content
        //            if let url = Bundle.main.url(forResource: "dune",
        //                                            withExtension: "png") {
        //                if let attachment = try? UNNotificationAttachment(identifier: "dune",
        //                                                                    url: url,
        //                                                                    options: nil) {
        //                    notificationContent.attachments = [attachment]
        //                }
        //            }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func resetNotificationData() {
        NotificationManager.shared.affirmationText = nil
        NotificationManager.shared.affirmationImage = nil 
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
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
