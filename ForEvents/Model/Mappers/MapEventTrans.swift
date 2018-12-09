//
//  MapEventTrans.swift
//  ForEvents
//
//  Created by luis gomez alonso on 09/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

func mapEventTransIntoEvent(eventTrans: EventTrans) -> Event {
    let event = Event(id: eventTrans.id, name: eventTrans.name)
    event.description = eventTrans.description
    event.beginDate = eventTrans.beginDate
    event.endDate = eventTrans.endDate
    event.country = eventTrans.country ?? ""
    event.province = eventTrans.province ?? ""
    event.city = eventTrans.city ?? ""
    event.address = eventTrans.address ?? ""
    event.zipCode = eventTrans.zipCode ?? ""
    event.indoor = eventTrans.indoor ?? false
    event.maxVisitors = eventTrans.maxVisitors ?? 0
    event.free = eventTrans.free ?? true
    event.price = eventTrans.price ?? 0
    event.minAge = eventTrans.minAge ?? 0
    event.eventType = eventTrans.eventType?.name ?? ""
    event.longitude = eventTrans.location.coordinates[0]
    event.latitude = eventTrans.location.coordinates[1]
    
    var images: [String] = []
    if eventTrans.media != nil {
        for image in (eventTrans.media!) {
            images.append(image.url)
        }
    }
    event.images = images
    
    return event
}
