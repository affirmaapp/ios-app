//
//  CountryModel.swift
//  Airblack
//
//  Created by Vidushi Jaiswal on 04/03/21.
//

import ObjectMapper
import Foundation

class CountryModel: NSObject, Mappable {
    
    var name: String?
    var code: String?
    var phoneCode: String?
    var flag: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name <- map["name"]
        code <- map["code"]
        phoneCode <- map["phone_code"]
        flag <- map["flag"]
    }
    
}
