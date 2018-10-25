//
//  User.swift
//  ForEvents
//
//  Created by luis gomez alonso on 25/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let email: String
    let password: String
    let firstname: String
    /*let lastname: String?
    let city: String?
    let province: String?
    let country: String?
    let zipCode: String?
    let alias: String?
    let gender: String?
    */
    init(email: String, password: String, firstname: String) {
        self.email = email
        self.password = password
        self.firstname = firstname
    }
}
