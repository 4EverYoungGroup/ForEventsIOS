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
    let user: GetUser?
}

struct GetUser: Codable {
    
    let email: String
    var password: String?
    let firstname: String
    let profile: String
    var lastname: String?
    var country: String?
    var province: String?
    var zipCode: String?
    var city: City?
    var alias: String?
    let gender: String?
    let birthdayDate: Date?
    
    enum CodingKeys: String, CodingKey
    {
        case email
        case password
        case firstname = "first_name"
        case profile
        case lastname = "last_name"
        case country
        case province
        case zipCode = "zip_code"
        case city
        case alias
        case gender
        case birthdayDate = "birthday_date"
    }
}
