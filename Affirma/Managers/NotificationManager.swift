//
//  NotificationManager.swift
//  Affirma
//
//  Created by Airblack on 30/01/23.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
    
    let notificationData = [
      "I am worthy of love and respect, and I will not settle for less.",
      "I trust myself to make the right decisions for my life.",
      "I release all negativity and welcome positivity and abundance into my life.",
      "I am confident in my abilities and trust that I will succeed.",
      "I am deserving of success and will work hard to achieve my goals.",
      "I embrace change and look forward to new opportunities.",
      "I am grateful for the blessings in my life, and I attract even more abundance.",
      "I am at peace with who I am, and I love myself unconditionally.",
      "I am capable of overcoming any challenge that comes my way.",
      "I trust the journey of my life and believe that everything happens for a reason.",
      "I am deserving of love, and I attract it into my life effortlessly.",
      "I let go of fear and step boldly into my power and potential.",
      "I am blessed with unique talents and strengths that serve me well.",
      "I release self-doubt and trust that I am enough exactly as I am.",
      "I am worthy of joy and happiness, and I create it in my life every day.",
      "I am deserving of abundance in all areas of my life, and I receive it now.",
      "I am capable of achieving greatness and will not let anything hold me back.",
      "I trust that the universe has a plan for me, and I am exactly where I need to be.",
      "I am grateful for my health and well-being, and I prioritize self-care.",
      "I am confident in my ability to handle any challenge that comes my way.",
      "I am worthy of respect and will not tolerate mistreatment from others.",
      "I trust that everything is working out for my highest good.",
      "I am open to new opportunities and experiences that will help me grow.",
      "I am deserving of success and will continue to work hard to achieve my goals.",
      "I release negative self-talk and embrace positive affirmations that uplift me.",
      "I am worthy of love and kindness, and I attract it into my life every day.",
      "I am blessed with a unique perspective and talents that make me valuable.",
      "I am capable of achieving my dreams and will not let anything stop me.",
      "I trust that the universe is conspiring in my favor, and I welcome abundance.",
      "I am grateful for the people in my life who love and support me unconditionally.",
      "I am confident in my ability to make decisions that align with my highest good.",
      "I am worthy of love and belonging, and I embrace my authentic self.",
      "I trust that I am on the right path, even when things don't go as planned.",
      "I am open to the endless possibilities that life has to offer.",
      "I am deserving of all the good things that life has to offer, and I receive them now.",
      "I release old patterns that no longer serve me and embrace new beginnings.",
      "I am capable of achieving anything I set my mind to, and I trust in myself.",
      "I trust that the universe is conspiring in my favor, and I welcome abundance.",
      "I am grateful for all the abundance in my life, and I attract even more.",
      "I am confident in my ability to overcome any obstacle that comes my way.",
      "I am worthy of respect and admiration, and I receive it from others easily.",
      "I trust that everything will work out in my favor, even when things are tough.",
      "I am constantly improving and evolving into a better version of myself.",
      "I am deserving of love, happiness, and success.",
      "I am open to new opportunities and experiences.",
      "I am worthy of all the good things that come my way.",
      "I am confident and self-assured in all that I do.",
      "I am at peace with who I am and where I am in life."
      ]
    
    @objc static let shared = NotificationManager()
    let exploreManager = ExploreManager()

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
                if granted {
                    EventManager.shared.trackEvent(event: .notificationPermissionGranted)
                } else {
                    EventManager.shared.trackEvent(event: .notificationPermissionNotGranted)
                }
                guard granted else {
                    return }
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
        let body = NotificationManager.shared.notificationData.randomElement() ?? ""
        
        notificationContent.title = "Affirma"
        notificationContent.body = body
        //            notificationContent.badge = NSNumber(value: 3)
        notificationContent.userInfo = ["affirmation": body]
        
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
