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
    var notificationTime: String?
    var state: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name <- map["name"]
        notificationTime <- map["notificationTime"]
        state <- map["state"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.notificationTime, forKey: "notificationTime")
        coder.encode(self.notificationTime, forKey: "state")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.notificationTime = aDecoder.decodeObject(forKey: "notificationTime") as? String ?? ""
        self.state = aDecoder.decodeObject(forKey: "state") as? String ?? ""
    }
}
