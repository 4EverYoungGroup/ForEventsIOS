//
//  Search.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

public class Search: Codable {
    
    let eventType: [String]?
    let id: String
    let user: String
    let query: String
    let name: String
    let createDate: Date
    
    enum CodingKeys: String, CodingKey
    {
        case eventType = "event_type"
        case id = "_id"
        case user
        case query
        case name = "name_search"
        case createDate = "create_date"
    }
    
}
