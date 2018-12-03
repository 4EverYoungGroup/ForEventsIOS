//
//  TransactionAdd.swift
//  ForEvents
//
//  Created by luis gomez alonso on 03/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct TransactionAdd: Codable {
    
    let eventId: String
    
    enum CodingKeys: String, CodingKey
    {
        case eventId = "event"
    }
    
    init(eventId: String) {
        self.eventId = eventId
    }
}
