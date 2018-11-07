//
//  EventAnnotation.swift
//  ForEvents
//
//  Created by luis gomez alonso on 07/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation
import MapKit

// Annotation class for event
class EventAnnotation: NSObject, MKAnnotation {
    
    // Creación de variables
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var event: Event
    
    // Init
    init(coordinate: CLLocationCoordinate2D, title: String?, event: Event) {
        self.coordinate   = coordinate
        self.title        = title
        self.event       = event
    }
    
}
