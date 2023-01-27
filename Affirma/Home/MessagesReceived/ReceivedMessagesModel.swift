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
    var data: [ReceivedMessagesDataModel]?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        data <- map["data"]
    }
}

class ReceivedMessagesDataModel: NSObject, Mappable, Codable {
    var sender_id: String?
    var card_id: String?
    var affirmation: String?
    var affirmation_image: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        sender_id <- map["sender_id"]
        card_id <- map["card_id"]
        affirmation <- map["affirmation"]
        affirmation_image <- map["affirmation_image"]
    }
}



