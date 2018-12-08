//
//  TransactionsListAPI.swift
//  ForEvents
//
//  Created by luis gomez alonso on 08/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct ResponseTransList: Codable {
    let ok: Bool
    let result: [TransList]?
    
    enum CodingKeys: String, CodingKey
    {
        case ok
        case result
    }
}

struct TransList: Codable {
    let id: String
    let createDate: Date
    let event: EventAPI
    let user: User
    
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case createDate = "create_date"
        case event
        case user
    }
}


