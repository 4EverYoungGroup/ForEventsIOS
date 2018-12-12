//
//  NotificationEvent.swift
//  ForEvents
//
//  Created by luis gomez alonso on 12/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct NotificationEvent: Codable {
    
    let eventId: String
    
    enum CodingKeys: String, CodingKey
    {
        case eventId = "event_id"
    }
}
