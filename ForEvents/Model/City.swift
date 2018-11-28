//
//  City.swift
//  ForEvents
//
//  Created by luis gomez alonso on 28/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct City: Codable {
    
    let id: String
    var city: String
    let province: String?
    let country: String?
    var zipCode: String?
    var location: Coordinates
    
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case city
        case province
        case country
        case zipCode = "zip_code"
        case location
    }
    
    init(id: String, city: String, province: String?, country: String?, zipCode: String?, location: Coordinates) {
        self.id = id
        self.city = city
        self.province = province
        self.country = country
        self.zipCode = zipCode
        self.location = location
    }
}

