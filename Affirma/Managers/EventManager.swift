//
//  EventManager.swift
//  Affirma
//
//  Created by Airblack on 17/02/23.
//

import Amplitude_iOS
import Foundation

class EventManager: NSObject {
    @objc static let shared = EventManager()
    
    private var userTrackingProfile: [String: Any] = [:] {
        didSet {
            Amplitude.instance().setUserProperties(userTrackingProfile)
        }
    }
    
    func updateUserTrackingProfile() {
        var trackingProfile = userTrackingProfile
        if let user = AffirmaStateManager.shared.activeUser {
            Amplitude.instance().setUserId(user.userId?.uuidString)
            
            trackingProfile["_id"] = user.userId
            trackingProfile["name"] = user.metaData?.name
            
            var userProfile = user.toJSON()
            userProfile.removeValue(forKey: "token")
            userTrackingProfile = userProfile
            
        }
    }
    
    func trackEvent(event: Event, properties: [String: Any] = [:]) {
        var finalProperties = properties
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = .current
        
        finalProperties["timeStamp"] = dateFormatter.string(from: Date())

        print("Firing: \(event.rawValue) with \(properties)")
       
        Amplitude.instance().logEvent(event.rawValue.uppercased(),
                                      withEventProperties: finalProperties)
    }
}
