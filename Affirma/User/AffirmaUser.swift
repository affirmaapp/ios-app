//
//  AffirmaUser.swift
//  Affirma
//
//  Created by Airblack on 15/01/23.
//

import Foundation
import ObjectMapper

class UserData: NSObject, Mappable, Codable {
    var name: String?
    var userId: UUID?
    var id: Int?
    var state: String?
    var notification_hour: Int?
    var notification_minute: Int?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name <- map["name"]
        userId <- map["user_id"]
        id <- map["id"]
        state <- map["state"]
        notification_hour <- map["notification_hour"]
        notification_minute <- map["notification_minute"]
    }
    
    init(withName name: String,
         withUserId userId: UUID,
         withId id: Int) {
        self.name = name
        self.userId = userId
        self.id = id
    }
}

class AffirmaUser: NSObject, Mappable, NSCoding {
    var userId: UUID?
    var phoneNumber: String?
    var metaData: AffirmaUserMetaData?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        userId <- map["user_id"]
        metaData <- map["data"]
        phoneNumber <- map["phone"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.userId, forKey: "user_id")
        coder.encode(self.phoneNumber, forKey: "phone")
        coder.encode(self.metaData, forKey: "data")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.userId = aDecoder.decodeObject(forKey: "user_id") as? UUID
        self.phoneNumber = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        self.metaData = aDecoder.decodeObject(forKey: "data") as? AffirmaUserMetaData
    }
}


class AffirmaUserMetaData: NSObject, Mappable, NSCoding {
    var name: String?
    var notification_hour: Int?
    var notification_minute: Int?
    var state: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name <- map["name"]
        notification_hour <- map["notification_hour"]
        notification_minute <- map["notification_minute"]
        state <- map["state"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.notification_hour, forKey: "notification_hour")
        coder.encode(self.notification_minute, forKey: "notification_minute")
        coder.encode(self.state, forKey: "state")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.notification_hour = aDecoder.decodeObject(forKey: "notification_hour") as? Int ?? 0
        self.notification_minute = aDecoder.decodeObject(forKey: "notification_minute") as? Int ?? 0
        self.state = aDecoder.decodeObject(forKey: "state") as? String ?? ""
    }
}
