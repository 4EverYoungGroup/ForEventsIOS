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
                                        subtitle: event.city,
                                        event: event)
        
        self.eventMap.addAnnotation(annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If the annotation is the user's point, we do nothing.
        if annotation is MKUserLocation {
            return nil
        }
        
        // An identifier is created for the pin
        let pinID = "eventPin"
        
        // Asked to assign an annotation to the pin
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID)
        
        // If there is no reusable annotation, create one
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinID)
            
            // It is activated to show the pin when you click on it
            pinView?.canShowCallout = true
            
            // Se informa la imagen de la tienda
            let eventImageview = UIImageView()
            if event!.images.isEmpty == false {
                let url = URL(string: event!.images[0])
                eventImageview.kf.setImage(with: url)
            }
            
            var rigthButton = UIButton(type: .detailDisclosure)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "maps"), for: .normal)
            rigthButton = mapsButton
            let leftButton = eventImageview
            leftButton.frame.size.height = 30
            leftButton.frame.size.width = 44
            
            pinView?.rightCalloutAccessoryView = rigthButton
            pinView?.leftCalloutAccessoryView = leftButton
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    // The event that is executed when clicking on one of the pins is picked up
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // The annotation data is obtained and the detail is invoked
        if let annotation = view.annotation as? EventAnnotation {
            let event = annotation.getEvent()
            
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(Global.citySelectedPosition![0]), longitude: Double(Global.citySelectedPosition![1]))))
            source.name = Global.citySelectedName
            
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(event.latitude!), longitude:    Double(event.longitude!))))
            destination.name = event.name
            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
