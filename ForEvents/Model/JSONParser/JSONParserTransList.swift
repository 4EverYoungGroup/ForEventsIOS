//
//  JSONParserTransList.swift
//  ForEvents
//
//  Created by luis gomez alonso on 08/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

func parseTransList(data: Data) -> Events {
    let events = Events()
    
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
        let jsonData = try decoder.decode(ResponseTransList.self, from: data)
        if let result = jsonData.result {
            //Filter transactions from JSON with requirements
            //Map TransactionCodable to Transaction class
            for transList in result {
                let transEvent = transList.event
                let event = mapEventAPIIntoEvent(eventAPI: transEvent)
                events.add(event: event)
            }
        }
    } catch let parsingError {
        activityIndicator.removeFromSuperview()
        print(parsingError)
    }
    return events
}
