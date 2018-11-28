//
//  EventTypeAPI.swift
//  ForEvents
//
//  Created by luis gomez alonso on 27/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct EventTypeAPI: Codable {
    let ok: Bool
    let result: [EventType]
}
