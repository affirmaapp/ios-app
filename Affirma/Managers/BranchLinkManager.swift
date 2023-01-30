//
//  BranchLinkManager.swift
//  Affirma
//
//  Created by Airblack on 29/01/23.
//

import Branch
import Foundation

class BranchLinkManager: NSObject {
    
    @objc static let shared = BranchLinkManager()
    
    func createLink(forModel model: SelectedThemeModel?,
                    completion: @escaping ((String?) -> Void)) {
        guard let model = model else {
            return
        }
        
        let buo = BranchUniversalObject.init(canonicalIdentifier: "sendAffirmation")
        buo.publiclyIndex = true
        buo.locallyIndex = true
        
        buo.title = "A Little Reminder of Your Incredible Strength and Potential"
        buo.contentDescription = ""
        buo.imageUrl = model.affirmation_image
        
        var metaTags: [String: String] = [:]
        var modelToShare = ReceivedMessagesDataModel(withSenderId: AffirmaStateManager.shared.activeUser?.userId?.uuidString,
                                                     withCardId: String(model.id ?? 1),
                                                     withAffirmation: model.affirmation,
                                                     withAffirmationImage: model.affirmation_image,
                                                     withSenderName: AffirmaStateManager.shared.activeUser?.metaData?.name,
                                                     withMessageId: String(NSDate().timeIntervalSince1970))
        
        let linkProperties = BranchLinkProperties()
        linkProperties.addControlParam("$custom_meta_tags", withValue: modelToShare.toJSONString())
        linkProperties.addControlParam("$deeplink_path", withValue: "affirmaapp.com/messagesReceived?shouldAdd=true")
        
        
        buo.getShortUrl(with: linkProperties) { (link, error) in
            if let link = link {
                print("LINK: \(link)")
                completion(link)
            }
        }
    }
    
}
