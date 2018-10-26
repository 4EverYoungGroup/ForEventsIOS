//
//  ResponseApi.swift
//  ForEvents
//
//  Created by luis gomez alonso on 25/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct ResponseApi: Codable {
    let ok: Bool
    let message: String
    
    init(ok: Bool, message: String) {
        self.ok = ok
        self.message = message
    }
}

