//
//  SendLoveModel.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Foundation
import ObjectMapper

class ThemeData: NSObject, Mappable, Codable {
    var id: Int?
    var theme_text: String?
    var theme_text_image: String?
    var theme_symbol_image: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        theme_text <- map["theme_text"]
        theme_text_image <- map["theme_text_image"]
        theme_symbol_image <- map["theme_symbol_image"]
    }
}


