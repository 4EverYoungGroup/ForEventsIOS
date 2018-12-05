//
//  TransactionAdd.swift
//  ForEvents
//
//  Created by luis gomez alonso on 03/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct TransactionApi: Codable {
    
    let transactionId: String?
    let createDate: Date?
    let eventId: String?
    let userId: String?
    
    enum CodingKeys: String, CodingKey
    {
        case transactionId = "_id"
        case createDate = "create_date"
        case eventId = "event"
        case userId = "user"
    }
    
    init(transactionId: String?, createDate: Date?, eventId: String?, userId: String?) {
        self.transactionId = transactionId
        self.createDate = createDate
        self.eventId = eventId
        self.userId = userId
    }
}
