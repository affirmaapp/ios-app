//
//  MeaningModel.swift
//  Affirma
//
//  Created by Airblack on 31/01/23.
//

import Foundation
import ObjectMapper

class MeaningModel: NSObject, Mappable, Codable {
    var id: Int?
    var image_url: String?
    var meaning: String?
    
    override init() {}
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        image_url <- map["image_url"]
        meaning <- map["meaning"]
    }
}
