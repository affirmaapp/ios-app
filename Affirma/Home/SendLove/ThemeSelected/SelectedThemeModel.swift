//
//  SelectedThemeModel.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Foundation
import ObjectMapper

class SelectedThemeModel: NSObject, Mappable, Codable {
    var id: Int?
    var affirmation: String?
    var affirmation_image: String?
    var theme: [String]?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        affirmation <- map["affirmation"]
        affirmation_image <- map["affirmation_image"]
        theme <- map["theme"]
    }
}

