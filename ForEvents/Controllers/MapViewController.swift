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
    
    var event: Event? = nil
    var filterButton: UIBarButtonItem = UIBarButtonItem()
    var startButtonOff: UIBarButtonItem = UIBarButtonItem()
    var startButtonOn: UIBarButtonItem = UIBarButtonItem()
    let eventsMapView = MKMapView()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title
        title = "Eventos"
        
        //Add to notification FindDidPress
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(findDidChange), name: NSNotification.Name(rawValue: FindDidPressNotificationName), object: nil)
        
        //Configure find Button
        self.configureFindAndStart()
        
        //Request location Authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        //Create map
        self.createMap()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Configure navigationBar opaque and black, status bar white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        self.eventsMapView.delegate = self
    }
    
    func configureFindAndStart() {
        let image = UIImage(named: "find")?.withRenderingMode(.alwaysOriginal)
        filterButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(findTapped))
        
        let imageOff = UIImage(named: "start")?.withRenderingMode(.alwaysOriginal)
        startButtonOff = UIBarButtonItem(image: imageOff, style: .plain, target: self, action: #selector(startTappedOff))
        
        let imageOn = UIImage(named: "startFilled")?.withRenderingMode(.alwaysOriginal)
        startButtonOn = UIBarButtonItem(image: imageOn, style: .plain, target: self, action: #selector(startTappedOn))
        
        navigationItem.rightBarButtonItems = [filterButton, startButtonOff]
    }
    
    @objc func findTapped() {
        let filterViewController = FindViewController()
        filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: true, completion: nil)
    }
    
    @objc func startTappedOff() {
        showFavoriteSearchDialog(title: "4Events",
                                 subtitle: "Guardar búsqueda como favorita.",
                                 actionTitle: "Guardar",
                                 cancelTitle: "Cancelar",
                                 inputPlaceholder: "Nombre búsqueda",
                                 inputKeyboardType: .default)
        { (input:String?) in
            print("El nombre de la búsqueda es: \(input ?? "")")
            ExecuteInteractorImpl().execute {
                //Pass dictionary with find params and favoriteSearch name
                self.saveFavoriteSearch(params: Global.findParamsDict as Dictionary<String, Any>, name: input ?? "Sin nombre", action: Constants.favoriteSearchAdd, favoriteSearchId: nil)
            }
        }
    }
    
    @objc func startTappedOn() {
        //Delete favoriteSearch - Alert
        let deleteFavoriteSearchAlertController = UIAlertController (title: "Atención, ha solicitado borrar su búsqueda", message: "Esta acción borrará su búsqueda favorita.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Borrar", style: .destructive) { (_) -> Void in
            //Delete favoriteSearch
            ExecuteInteractorImpl().execute {
                //Pass favoriteSearchId
                self.saveFavoriteSearch(params: Global.findParamsDict as Dictionary<String, Any>, name: nil, action: Constants.favoriteSearchDelete, favoriteSearchId: Global.favoriteSearchIdLast)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        deleteFavoriteSearchAlertController .addAction(settingsAction)
        deleteFavoriteSearchAlertController .addAction(cancelAction)
        self.present(deleteFavoriteSearchAlertController, animated: true, completion: nil)
    }
    
    func saveFavoriteSearch(params: Dictionary<String, Any>?, name: String?, action: String, favoriteSearchId: String?) {
        let favoriteSearchInteractor: FavoriteSearchInteractor = FavoriteSearchInteractorNSURLSessionImpl()
        
        favoriteSearchInteractor.execute(params: params, name: name, action: action, favoriteSearchId: favoriteSearchId) { (responseApi: ResponseApi?) in
            // Todo OK
            if responseApi == nil {
                if action == Constants.favoriteSearchAdd {
                    self.navigationItem.setRightBarButtonItems([self.filterButton, self.startButtonOn], animated: false)
                } else {
                    self.navigationItem.setRightBarButtonItems([self.filterButton, self.startButtonOff], animated: false)
                }
            } else {
                if let message = responseApi?.message {
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let message = responseApi?.error?.message else { return }
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func eventsDownload(params: Dictionary<String, Any>) {
        let downloadEventsInteractor: DownloadEventsInteractor = DownloadEventsInteractorNSURLSessionImpl()
        
        downloadEventsInteractor.execute(params: params) { (events: Events) in
            // Todo OK
            //if events.count() > 0 {
            Global.events = events
            Global.transactionIdLast = nil
            //Create map
            self.createMap()
            //} else {
            //TODO alert with no events
            //}
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
        let center = CLLocationCoordinate2D(latitude: Double(Global.citySelectedPosition![0]), longitude: Double(Global.citySelectedPosition![1]))
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 0, longitudinalMeters: CLLocationDistance(Global.distanceInMetres))
        eventsMapView.setRegion(region, animated: true)
        
        view.addSubview(eventsMapView)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        //Delete previous annotations
        let allAnnotations = self.eventsMapView.annotations
        self.eventsMapView.removeAnnotations(allAnnotations)
        // Create anotation for event
        if let numberEvents = Global.events?.count() {
            for i in 0..<numberEvents {
                if let event = Global.events?.get(index: i) {
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
            if event.images.isEmpty == false {
                let url = URL(string: event.images[0])
                eventImageview.kf.setImage(with: url)
            } else {
                let url = URL(string: "https://cdn.pixabay.com/photo/2017/11/24/10/43/admission-2974645_960_720.jpg")
                eventImageview.kf.setImage(with: url)
            }
            
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
    
    func showFavoriteSearchDialog(title:String? = nil,
                                  subtitle:String? = nil,
                                  actionTitle:String? = nil,
                                  cancelTitle:String? = nil,
                                  inputPlaceholder:String? = nil,
                                  inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                                  cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                  actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Mark: - Notifications
    @objc func findDidChange(notification: Notification) {
        //Recover findParameters
        let info = notification.userInfo!
        //extract the selected day
        let findParameters = info[FindKey]
        eventsDownload(params: findParameters as! Dictionary<String, Any>)
    }

}
