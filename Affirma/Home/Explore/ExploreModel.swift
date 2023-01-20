//
//  ExploreModel.swift
//  Affirma
//
//  Created by Airblack on 20/01/23.
//

import Foundation
import ObjectMapper

class AffirmationImage: NSObject, Mappable, Codable {
    var id: Int?
    var image_url: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        image_url <- map["image_url"]
    }
}

class AffirmationText: NSObject, Mappable, Codable {
    var id: Int?
    var text: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        text <- map["text"]
    }
}
