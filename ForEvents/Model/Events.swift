//
//  Events.swift
//  ForEvents
//
//  Created by luis gomez alonso on 01/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol EventsProtocol {
    func count() -> Int
    func add(event: Event)
    func get(index: Int) -> Event
}

public class Events: EventsProtocol {
    private var eventsList: [Event]?
    
    public init() {
        self.eventsList = []
    }
    
    public func count() -> Int {
        return (eventsList?.count)!
    }
    
    public func add(event: Event) {
        eventsList?.append(event)
    }
    
    public func get(index: Int) -> Event {
        return (eventsList?[index])!
    }
    
}
