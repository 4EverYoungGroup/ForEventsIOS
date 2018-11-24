//
//  ResponseApi.swift
//  ForEvents
//
//  Created by luis gomez alonso on 25/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct ResponseApi: Codable {
    let ok: Bool
    let errors: [ErrorDescription]?
    let message: String?
    let error: ErrorRecover?
}

struct ErrorDescription: Codable {
    let field: String?
    let message: String?
}

struct ErrorRecover: Codable {
    let message: String
}


