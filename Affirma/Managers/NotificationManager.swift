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
  
    
    var affirmationImagesList: [AffirmationImage] = []
    var affirmationTextList: [AffirmationText] = []
    
    var affirmationImage: String?
    var affirmationText: String?
    
    override init() {
        super.init()

    }
    
    func doWeHavePermission(completion: @escaping ((Bool) -> Void)) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func askForUsersPermission(completion: @escaping ((Bool) -> Void)) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] granted, _ in
                completion(true)
                print("Permission granted: \(granted)")
                guard granted else {
                    return }
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
    
    func resetNotificationData() {
        NotificationManager.shared.affirmationText = nil
        NotificationManager.shared.affirmationImage = nil 
    }
    
    func removePendingNotification() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["selfAffirmationNotification"])
    }
    
    func scheduleNotification() {
        removePendingNotification()
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        let body = NotificationManager.shared.affirmationTextList.randomElement()?.text ?? ""
        let image = NotificationManager.shared.affirmationImagesList.randomElement()?.image_url ?? ""
        
        notificationContent.title = "Affirma"
        notificationContent.body = body
        //            notificationContent.badge = NSNumber(value: 3)
        notificationContent.userInfo = ["affirmation": body,
                                        "affirmation_image": image]
        
        //         Add an attachment to the notification content
        if let url = Bundle.main.url(forResource: "energy",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "energy",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        var datComp = DateComponents()
        datComp.hour = AffirmaStateManager.shared.activeUser?.metaData?.notification_hour
        datComp.minute = AffirmaStateManager.shared.activeUser?.metaData?.notification_minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)

        let request = UNNotificationRequest(identifier: "selfAffirmationNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
}
