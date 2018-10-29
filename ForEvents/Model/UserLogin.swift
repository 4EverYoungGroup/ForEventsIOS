//
//  UserLogin.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct UserLogin: Codable {
    
    let email: String
    let password: String?
    let token: String?
    
    init(email: String, password: String?, token: String?) {
        self.email = email
        self.password = password
        self.token = token
    }
}
