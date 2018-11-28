//
//  EventType.swift
//  ForEvents
//
//  Created by luis gomez alonso on 27/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct EventType: Codable {
    let id: String?
    let name: String
    
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case name
    }
}
