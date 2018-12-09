//
//  UserLogin.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct UserLogin: Codable {
    
    let email: String?
    let password: String?
    let token: String?
    let user: UserApiLogin?
    
    init(email: String?, password: String?, token: String?, user: UserApiLogin?) {
        self.email = email
        self.password = password
        self.token = token
        self.user = user
    }
}

struct UserApiLogin: Codable {
    let id: String
    let city: City?
    let firstName: String
    let lastName: String?
    
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case city
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
