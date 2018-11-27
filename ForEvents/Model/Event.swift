//
//  Event.swift
//  ForEvents
//
//  Created by luis gomez alonso on 01/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

public class Event {
    var id: String
    var name: String
    var description: String? = nil
    var beginDate: Date? = nil
    var endDate: Date? = nil
    var country: String? = nil
    var province: String? = nil
    var city: String? = nil
    var address: String? = nil
    var zipCode: String? = nil
    var indoor: Bool? = nil
    var maxVisitors: Int? = nil
    var free: Bool? = nil
    var price: Double? = nil
    var minAge: Int? = nil
    var eventType: String? = nil
    var latitude: Float? = nil
    var longitude: Float? = nil
    var images: [String] = []
    
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

}
