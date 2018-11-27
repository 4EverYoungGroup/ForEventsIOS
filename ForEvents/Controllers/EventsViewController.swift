//
//  EventsViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation

class EventsViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    let eventCollectionViewCellId = "EventCollectionViewCell"
    let headerCollectionViewId = "SectionHeader"
    var resultSearchController : UISearchController!
    
    let locationManager = CLLocationManager()
    var locationAuth: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        //Set title
        title = "Eventos"
        
        //Configure searchBar
        //self.configureSearch()
        
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
        
        ExecuteInteractorImpl().execute {
            eventsDownload()
        }
    }

    func eventsDownload() {
        let downloadEventsInteractor: DownloadEventsInteractor = DownloadEventsInteractorNSURLSessionImpl()
        
        downloadEventsInteractor.execute { (events: Events) in
            // Todo OK
            if events.count() > 0 {
                Global.events = events
                
                self.eventsCollectionView.delegate = self
                self.eventsCollectionView.dataSource = self
                self.eventsCollectionView.reloadData()
            } else {
                //TODO alert with no events
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // TODO implement search
        let searchString = searchController.searchBar.text
        
        if resultSearchController.isActive == true {
            self.navigationItem.rightBarButtonItem = nil
        }  else {
            self.configureFind()
        }
    }
    
    func configureSearch() {
        self.resultSearchController = UISearchController(searchResultsController:  nil)
        self.resultSearchController.searchResultsUpdater = (self as UISearchResultsUpdating)
        self.resultSearchController.delegate = (self as UISearchControllerDelegate)
        self.resultSearchController.searchBar.delegate = (self as UISearchBarDelegate)
        self.resultSearchController.hidesNavigationBarDuringPresentation = false
        self.resultSearchController.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        self.navigationItem.titleView = resultSearchController.searchBar
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
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
        let filterViewController = FilterViewController()
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
        print("Current location: \(currentLocation)")
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
            self.startEvents()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            self.locationAuth = true
            self.startEvents()
            break
        case .restricted:
            break
        case .denied:
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
        let loginTabBarController = createLoginTabBar()
        //Show login in tabbar
        loginTabBarController.selectedIndex = 0
        //Configure tabbar without background and shadow
        loginTabBarController.tabBar.backgroundImage = UIImage()
        loginTabBarController.tabBar.shadowImage = UIImage()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginTabBarController
    }
}
