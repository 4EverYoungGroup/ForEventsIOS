//
//  TransactionApiResponse.swift
//  ForEvents
//
//  Created by luis gomez alonso on 05/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct TransactionApiResponse: Codable {
    let ok: Bool
    let message: String
    let data: Transac
}

struct Transac: Codable {
    
    let transactionId: String?
    
    enum CodingKeys: String, CodingKey
    {
        case transactionId = "_id"
    }
}
