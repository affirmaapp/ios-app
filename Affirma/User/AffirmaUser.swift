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
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name <- map["name"]
        userId <- map["userId"]
        id <- map["id"]
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
        userId <- map["_id"]
        metaData <- map["data"]
        phoneNumber <- map["phone"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.userId, forKey: "userId")
        coder.encode(self.phoneNumber, forKey: "phone")
        coder.encode(self.metaData, forKey: "data")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.userId = aDecoder.decodeObject(forKey: "userId") as? UUID
        self.phoneNumber = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        self.metaData = aDecoder.decodeObject(forKey: "data") as? AffirmaUserMetaData
    }
}


class AffirmaUserMetaData: NSObject, Mappable, NSCoding {
    var name: String?
    var notificationHour: Int?
    var notificationMinute: Int?
    var state: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name <- map["name"]
        notificationHour <- map["notificationHour"]
        notificationMinute <- map["notificationMinute"]
        state <- map["state"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.notificationHour, forKey: "notificationHour")
        coder.encode(self.notificationMinute, forKey: "notificationMinute")
        coder.encode(self.state, forKey: "state")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.notificationHour = aDecoder.decodeObject(forKey: "notificationHour") as? Int ?? 0
        self.notificationMinute = aDecoder.decodeObject(forKey: "notificationMinute") as? Int ?? 0
        self.state = aDecoder.decodeObject(forKey: "state") as? String ?? ""
    }
}
