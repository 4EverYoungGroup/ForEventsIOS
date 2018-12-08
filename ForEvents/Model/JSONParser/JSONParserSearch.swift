//
//  JSONParserSearch.swift
//  ForEvents
//
//  Created by luis gomez alonso on 08/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

func parseSearches(data: Data) -> Searches {
    let searches = Searches()
    
    do {
        //Create custom decoder to treat the date field that may be invalid
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let dateISO8601 = DateFormatter()
            dateISO8601.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            var tmpDate: Date? = nil
            tmpDate = dateISO8601.date(from: dateStr)
            
            guard let date = tmpDate else {
                let dateInit = Date.init(timeIntervalSince1970: 86399)
                return dateInit
            }
            return date
        })
        let jsonData = try decoder.decode(FavoriteSearchsAPI.self, from: data)
        let result = jsonData.result
        //Filter transactions from JSON with requirements
        //Map TransactionCodable to Transaction class
        for search in result {
            searches.add(search: search)
        }
    } catch let parsingError {
        activityIndicator.removeFromSuperview()
        print(parsingError)
    }
    return searches
}
