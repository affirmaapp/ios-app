//
//  ReceivedMessagesModel.swift
//  Affirma
//
//  Created by Airblack on 27/01/23.
//

import Foundation
import ObjectMapper

class ReceivedMessagesBaseModel: NSObject, Mappable, Codable {
    var id: Int?
    var messages: [ReceivedMessagesDataModel]?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        messages <- map["messages"]
    }
    
    init(withData data: [ReceivedMessagesDataModel]?) {
        self.messages = data
    }
}

class ReceivedMessagesDataModel: NSObject, Mappable, Codable {
    var sender_id: String?
    var card_id: String?
    var affirmation: String?
    var affirmation_image: String?
    var sender_name: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        sender_id <- map["sender_id"]
        card_id <- map["card_id"]
        affirmation <- map["affirmation"]
        affirmation_image <- map["affirmation_image"]
        sender_name <- map["sender_name"]
    }
    
    init(withSenderId senderId: String?,
         withCardId cardId: String?,
         withAffirmation affirmation: String?,
         withAffirmationImage affirmationImage: String?,
         withSenderName senderName: String?) {
        self.sender_id = senderId
        self.card_id = cardId
        self.affirmation = affirmation
        self.affirmation_image = affirmationImage
        self.sender_name = senderName
    }
}



