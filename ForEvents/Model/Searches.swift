//
//  Searches.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol SearchesProtocol {
    func count() -> Int
    func add(search: Search)
    func get(index: Int) -> Search
}

public class Searches: SearchesProtocol {
    private var searchesList: [Search]?
    
    public init() {
        self.searchesList = []
    }
    
    public func count() -> Int {
        return (searchesList?.count)!
    }
    
    public func add(search: Search) {
        searchesList?.append(search)
    }
    
    public func get(index: Int) -> Search {
        return (searchesList?[index])!
    }
    
}
