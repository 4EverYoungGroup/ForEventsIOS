//
//  EventsViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation

class EventsViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var events: Events?

    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    let eventCollectionViewCellId = "EventCollectionViewCell"
    let headerCollectionViewId = "SectionHeader"
    var resultSearchController : UISearchController!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set title
        title = "Eventos"
        
        //Request location Authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        //Configure searchBar
        self.configureSearch()
        
        //Configure filter Button
        self.configureFilter()
        
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
}
