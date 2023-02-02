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
    
//    init() {
//        self.exploreManager = ExploreManager()
//    }
    func askForUsersPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] granted, _ in
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
    
}
