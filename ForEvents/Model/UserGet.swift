//
//  UserGet.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct UserGet: Codable {
    
    let ok: Bool?
    let message: String?
    let user: User?
}
