//
//  EventTrans.swift
//  ForEvents
//
//  Created by luis gomez alonso on 09/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct EventTrans: Codable {
    let id: String
    let name: String
    let description: String?
    let beginDate: Date
    let endDate: Date
    let country: String?
    let province: String?
    let city: String?
    let address: String?
    let zipCode: String?
    let indoor: Bool?
    let maxVisitors: Int?
    let free: Bool?
    let price: Double?
    let minAge: Int?
    let eventType: NameEventType?
    let location: Coordinates
    let transactions: [String]?
    let media: [ImageURL]?
    
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case name
        case description
        case beginDate = "begin_date"
        case endDate  = "end_date"
        case country
        case province
        case city
        case address
        case zipCode = "zip_code"
        case indoor
        case maxVisitors = "max_visitors"
        case free
        case price
        case minAge = "min_age"
        case eventType = "event_type"
        case location
        case transactions
        case media
    }
}
