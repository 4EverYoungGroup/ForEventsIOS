//
//  EventTypeCheck.swift
//  ForEvents
//
//  Created by luis gomez alonso on 27/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

public class EventTypeCheck {
    var id: String
    var name: String
    var check: Bool
    
    public init(id: String, name: String, check: Bool) {
        self.id = id
        self.name = name
        self.check = check
    }
}
