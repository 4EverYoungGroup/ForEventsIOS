//
//  MapEvent.swift
//  ForEvents
//
//  Created by luis gomez alonso on 25/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

func mapEventAPIIntoEvent(eventAPI: EventAPI) -> Event {
    let event = Event(id: eventAPI.id, name: eventAPI.name)
    event.description = eventAPI.description
    event.beginDate = eventAPI.beginDate
    event.endDate = eventAPI.endDate
    event.country = eventAPI.country ?? ""
    event.province = eventAPI.province ?? ""
    event.city = eventAPI.city ?? ""
    event.address = eventAPI.address ?? ""
    event.zipCode = eventAPI.zipCode ?? ""
    event.indoor = eventAPI.indoor ?? false
    event.maxVisitors = eventAPI.maxVisitors ?? 0
    event.free = eventAPI.free ?? true
    event.price = eventAPI.price ?? 0
    event.minAge = eventAPI.minAge ?? 0
    event.eventType = eventAPI.eventType?.name ?? ""
    event.longitude = eventAPI.location.coordinates[0]
    event.latitude = eventAPI.location.coordinates[1]
    if eventAPI.transactions!.count > 0 {
        event.transactionId = eventAPI.transactions![0]._id
    } else {
        event.transactionId = nil
    }
    var images: [String] = []
    if eventAPI.media != nil {
        for image in (eventAPI.media!) {
            images.append(image.url)
        }
    }
    event.images = images
    
    return event
}
