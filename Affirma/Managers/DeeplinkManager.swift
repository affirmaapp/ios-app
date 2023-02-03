//
//  DeeplinkManager.swift
//  Affirma
//
//  Created by Airblack on 24/01/23.
//

import Foundation
import UIKit

enum Host: String {
    case messagesReceived
}

enum DeeplinkType {
    case messagesReceived(shouldAddToList: Bool?)
}

class DeeplinkManager: NSObject {
    @objc static let shared = DeeplinkManager()
    
    
    func handle(deeplink: String?,
                shouldPresent: Bool?,
                withDeeplinkType deeplinkType: DeeplinkType? = nil,
                deeplinkSource: String? = nil,
                affirmationToAdd: ReceivedMessagesBaseModel? = nil) {
        var type: DeeplinkType?
        var viewController: UIViewController?
        
        if let deeplinkType = deeplinkType {
            type = deeplinkType
        } else {
            type = parseDeeplink(withDeeplinkString: deeplink)
        }
        
        if let deeplinkType = type {
            switch deeplinkType {
            case .messagesReceived(shouldAddToList: let shouldAddToList):
                var userInfo: [String: Any] = [:]
                userInfo["shouldAddToList"] = shouldAddToList
                userInfo["affirmationToAdd"] = affirmationToAdd
                
                if let messages = affirmationToAdd?.messages {
                    for message in messages {
                        if message.sender_id == AffirmaStateManager.shared.activeUser?.userId?.uuidString {
                            userInfo["shouldAddToList"] = false
                        }
                    }
                }
                
                NotificationCenter.default.post(name: AffirmaNotification.switchToMessagesRecieved,
                                                object: nil,
                                                userInfo: userInfo)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    NotificationCenter.default.post(name: AffirmaNotification.addMessage,
                                                    object: nil,
                                                    userInfo: userInfo)
                }
            }
        }
    }
    
    
    func parseDeeplink(withDeeplinkString deeplinkString: String?) -> DeeplinkType? {
        guard let deeplinkString = deeplinkString else {
            return nil
        }
        
        guard let escapedString = deeplinkString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        guard let url = URL(string: escapedString) else {
            return nil
        }
        
        UserDefaultsManager.shared.deeplink = deeplinkString
        
        let source = Utility.getQueryStringParameter(url: escapedString, param: "source")?.removingPercentEncoding ?? "Deeplink"
        
        let components = url.pathComponents
        var host: String = ""
        
        host = url.host ?? ""
        if components.count > 1 {
            host = components[1]
        }
        
        var properties: [String: Any] = [:]
        properties["deeplink"] = escapedString
        properties["source"] = source

        if let host = Host(rawValue: host) {
            switch host {
            case .messagesReceived:
                print("")
                let shouldAdd = Utility.getQueryStringParameter(url: escapedString,
                                                                      param: "shouldAdd")
                return DeeplinkType.messagesReceived(shouldAddToList: shouldAdd == "true" ? true : false)
            }
        }
        
        return nil 
    }
}
