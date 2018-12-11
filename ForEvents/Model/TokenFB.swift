//
//  TokenFB.swift
//  ForEvents
//
//  Created by luis gomez alonso on 11/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct TokenFB: Codable {
    
    let tokenFB: String
    
    init(tokenFB: String) {
        self.tokenFB = tokenFB
    }
}
