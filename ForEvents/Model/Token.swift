//
//  Token.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct Token: Codable {
    
    let token: String
    
    init(token: String) {
        self.token = token
    }
}
