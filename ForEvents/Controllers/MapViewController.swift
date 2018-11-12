//
//  MapViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var events: Events?
    
    var event: Event? = nil
    
    let eventsMapView = MKMapView()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title
        title = "Eventos"
        
        //Request location Authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        //Download Events
        ExecuteInteractorImpl().execute {
            eventsDownload()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Configure navigationBar opaque and black, status bar white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    func eventsDownload() {
        let downloadEventsInteractor: DownloadEventsInteractor = DownloadEventsInteractorFakeImpl()
        
        downloadEventsInteractor.execute { (events: Events) in
            // Todo OK
            self.events = events
            //Create map
            self.createMap()
            
            self.eventsMapView.delegate = self
        }
    }
    
    func createMap() {
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = 818
        
        eventsMapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        eventsMapView.mapType = MKMapType.standard
        eventsMapView.isZoomEnabled = true
        eventsMapView.isScrollEnabled = true
        
        //Center map to city location
        //TODO recuperar la posición de la city
        let center = CLLocationCoordinate2D(latitude: Double(40.155365), longitude: Double(-5.241073))
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 0, longitudinalMeters: 1000)
        eventsMapView.setRegion(region, animated: true)
        
        view.addSubview(eventsMapView)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        // Create anotation for event
        if let numberEvents = events?.count() {
            for i in 0..<numberEvents {
                if let event = events?.get(index: i) {
                    self.event = event
                    createAnotation(event: self.event!)
                }
            }
        }
    }
    
    func createAnotation(event: Event) {
        let eventLocation = CLLocation(latitude: CLLocationDegrees(event.latitude ?? 0),
                                       longitude: CLLocationDegrees(event.longitude ?? 0))
        
        let annotation = EventAnnotation(coordinate: eventLocation.coordinate,
                                         title: event.name,
                                         event: event)
        
        self.eventsMapView.addAnnotation(annotation)
        
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
            
            // An annotation is created with the selected event
            let event = (annotation as! EventAnnotation).getEvent()
            // Add The image of the event
            let eventImageview = UIImageView()
            event.images[0].loadImage(into: eventImageview)
            
            let rigthButton = UIButton(type: .detailDisclosure)
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
            let eventDetailViewController = EventDetailViewController()
            let event = annotation.getEvent()
            eventDetailViewController.event = event
            
            navigationController?.pushViewController(eventDetailViewController, animated: true)
        }
        
    }

}
