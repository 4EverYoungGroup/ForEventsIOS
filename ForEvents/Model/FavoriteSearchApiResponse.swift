//
//  FavoriteSearchApiResponse.swift
//  ForEvents
//
//  Created by luis gomez alonso on 06/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct FavoriteSearchApiResponse: Codable {
    let ok: Bool
    let message: String
    let data: FavoriteSearch
}

struct FavoriteSearch: Codable {
    
    let favoriteSerchId: String?
    
    enum CodingKeys: String, CodingKey
    {
        case favoriteSerchId = "_id"
    }
}
