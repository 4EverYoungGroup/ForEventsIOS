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
        self.configureSearch()
        
        //Configure filter Button
        self.configureFilter()
        
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
        let downloadEventsInteractor: DownloadEventsInteractor = DownloadEventsInteractorFakeImpl()
        
        downloadEventsInteractor.execute { (events: Events) in
            // Todo OK
            Global.events = events
            
            self.eventsCollectionView.delegate = self
            self.eventsCollectionView.dataSource = self
            self.eventsCollectionView.reloadData()
            
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // TODO implement search
        let searchString = searchController.searchBar.text
        
        if resultSearchController.isActive == true {
            self.navigationItem.rightBarButtonItem = nil
        }  else {
            self.configureFilter()
        }
    }
    
    @objc func filterTapped() {
        let filterViewController = FilterViewController()
        filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: true, completion: nil)
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
    
    func configureFilter() {
        var filterButton: UIBarButtonItem = UIBarButtonItem()
        filterButton = UIBarButtonItem(title: "Filtros", style: .plain, target: self, action: #selector(filterTapped))
        filterButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem = filterButton
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
}
