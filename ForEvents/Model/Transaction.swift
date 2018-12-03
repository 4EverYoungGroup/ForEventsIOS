//
//  Transaction.swift
//  ForEvents
//
//  Created by luis gomez alonso on 03/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    
    let id: String
    let createDate: Date?
    let event: Event?
    let user: User?
    
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case createDate = "create_date"
        case user
        case event
    }
    
    init(id: String, createDate: Date?, event: Event?, user: User?) {
        self.id = id
        self.createDate = createDate
        self.event = event
        self.user = user
    }
}
