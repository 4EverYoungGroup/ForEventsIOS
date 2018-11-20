//
//  Search.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

public class Search {
    var query: String
    var createDate: Date
    var eventsTypes: [String] = []
    
    public init(query: String, createDate: Date) {
        self.query = query
        self.createDate = createDate
    }
}
