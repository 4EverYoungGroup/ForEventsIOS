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
    let profile: String
    let lastname: String?
    let country: String?
    let province: String?
    let zipCode: String?
    let city: String?
    let alias: String?
    let gender: String
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
    
    init(email: String, password: String, firstname: String, profile: String, lastname: String?, country: String?, province: String?, zipCode: String?, city: String?, alias: String?, gender: String, birthdayDate: Date?) {
        self.email = email
        self.password = password
        self.firstname = firstname
        self.profile = profile
        self.lastname = lastname
        self.country = country
        self.province = province
        self.zipCode = zipCode
        self.city = city
        self.alias = alias
        self.gender = gender
        self.birthdayDate = birthdayDate
    }
}
