//
//  FavoriteSearchsAPI.swift
//  ForEvents
//
//  Created by luis gomez alonso on 08/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct FavoriteSearchsAPI: Codable {
    let ok: Bool
    let total: Int
    let result: [Search]
}

