//
//  EventsViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation

class EventsViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    let eventCollectionViewCellId = "EventCollectionViewCell"
    let headerCollectionViewId = "SectionHeader"
    
    let locationManager = CLLocationManager()
    var locationAuth: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        //Set title
        title = "Eventos"
        //Add to notification FindDidPress
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(findDidChange), name: NSNotification.Name(rawValue: FindDidPressNotificationName), object: nil)
        
        //Configure logout Button
        self.configureLogout()
        //Configure find Button
        self.configureFind()
        
        //Validate location Authorization
        self.validateLocationAuthorization()
        
        if  locationAuth == true {
            self.startEvents()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Configure navigationBar opaque and black, status bar white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    deinit {
        //Delete notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    func startEvents() {
        //Configure activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        //register header
        eventsCollectionView.register(UINib(nibName: "SectionHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCollectionViewId)
        //register cell
        let nibCell = UINib(nibName: eventCollectionViewCellId, bundle: nil)
        eventsCollectionView.register(nibCell, forCellWithReuseIdentifier: eventCollectionViewCellId)
        
        //TODO recoger posicion antes de llamar a API
        if Global.citySelectedPosition?.count == 0 {
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        }
        
        ExecuteInteractorImpl().execute {
            //TODO pass self location or favorite city location
            let params = [
                "position": Global.citySelectedPosition ?? [0,0],
                "queryText": nil,
                "eventTypes": nil,
                "distance": 5000] as Dictionary
            eventsDownload(params: params as Dictionary<String, Any>)
        }
    }

    func eventsDownload(params: Dictionary<String, Any>) {
        let downloadEventsInteractor: DownloadEventsInteractor = DownloadEventsInteractorNSURLSessionImpl()
        
        downloadEventsInteractor.execute(params: params) { (events: Events) in
            // Todo OK
            //if events.count() > 0 {
                Global.events = events
                
                self.eventsCollectionView.delegate = self
                self.eventsCollectionView.dataSource = self
                self.eventsCollectionView.reloadData()
            //} else {
                //TODO alert with no events
            //}
        }
    }
    
    func configureFind() {
        var filterButton: UIBarButtonItem = UIBarButtonItem()
        let image = UIImage(named: "find")?.withRenderingMode(.alwaysOriginal)
        filterButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(findTapped))
        filterButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem = filterButton
    }
    
    func configureLogout() {
        var logoutButton: UIBarButtonItem = UIBarButtonItem()
        let image = UIImage(named: "logoutUser")?.withRenderingMode(.alwaysOriginal)
        logoutButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(logoutTapped))
        logoutButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)!], for: .normal)
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func findTapped() {
        let filterViewController = FindViewController()
        filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: true, completion: nil)
    }
    
    @objc func logoutTapped() {
        //Logout user - Alert
        let logoutUserAlertController = UIAlertController (title: "Atención, ha solicitado salir de la app", message: "Esta acción le desconectará de la app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Salir", style: .destructive) { (_) -> Void in
            //Delete user
            self.logoutUser()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        logoutUserAlertController .addAction(settingsAction)
        logoutUserAlertController .addAction(cancelAction)
        self.present(logoutUserAlertController, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(viewController)
    }
    
    func validateLocationAuthorization() {
        
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Localización no disponible", message: "Por favor, habilite la localización en Ajustes", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            self.locationAuth = true
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        Global.citySelectedPosition = []
        Global.citySelectedPosition?.append(Float(currentLocation.coordinate.latitude))
        Global.citySelectedPosition?.append(Float(currentLocation.coordinate.longitude))
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            self.locationAuth = true
            if UserDefaults.standard.bool(forKey: Constants.locationAuth) == false {
                self.startEvents()
                UserDefaults.standard.setValue(true, forKey: Constants.locationAuth)
            }
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            if UserDefaults.standard.bool(forKey: Constants.locationAuth) == false {
                self.startEvents()
                UserDefaults.standard.setValue(true, forKey: Constants.locationAuth)
            }
            break
        case .restricted:
            break
        case .denied:
            UserDefaults.standard.setValue(false, forKey: Constants.locationAuth)
            // If restricted by e.g. parental controls. User can't enable Location Services
            let alert = UIAlertController(title: "Localización no disponible", message: "Por favor, habilite la localización en Ajustes", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func logoutUser() {
        UserDefaults.standard.set(false, forKey: "hasLoginKey")
        let loginTabBarController = createLoginTabBar()
        //Show login in tabbar
        loginTabBarController.selectedIndex = 0
        //Configure tabbar without background and shadow
        loginTabBarController.tabBar.backgroundImage = UIImage()
        loginTabBarController.tabBar.shadowImage = UIImage()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginTabBarController
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
