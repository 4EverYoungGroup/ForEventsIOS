//
//  EventDetailViewController+MapKit.swift
//  ForEvents
//
//  Created by luis gomez alonso on 07/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension EventDetailViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        // Create anotation for event
        createAnotation(event: event!)
    }
    
    func createAnotation(event: Event) {
        let eventLocation = CLLocation(latitude: CLLocationDegrees(event.latitude ?? 0),
                                       longitude: CLLocationDegrees(event.longitude ?? 0))
        
        let annotation = EventAnnotation(coordinate: eventLocation.coordinate,
                                        title: event.name,
                                        event: event)
        
        self.eventMap.addAnnotation(annotation)
        
        //Center map to event location
        let center = CLLocationCoordinate2D(latitude: Double(event.latitude!), longitude: Double(event.longitude!))
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 0, longitudinalMeters: 250)
        eventMap.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If the annotation is the user's point, we do nothing.
        if annotation is MKUserLocation {
            return nil
        }
        
        // An identifier is created for the pin
        let pinID = "shopPin"
        
        // Asked to assign an annotation to the pin
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID)
        
        // If there is no reusable annotation, create one
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinID)
            
            // It is activated to show the pin when you click on it
            pinView?.canShowCallout = true
            
            let rigthButton = UIButton(type: .detailDisclosure)
            
            pinView?.rightCalloutAccessoryView = rigthButton
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
}
