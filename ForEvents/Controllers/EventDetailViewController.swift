//
//  EventDetailViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 05/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBOutlet weak var assistButton: UIButton!
    
    @IBOutlet weak var photosLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventDesTextView: UITextView!
    
    @IBOutlet weak var eventMap: MKMapView!
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    var event: Event?
    
    let eventDetailCollectionViewCellId = "EventDetailCollectionViewCell"
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        //Configure assistButton aspect
        //assistButton.backgroundColor = .clear
        assistButton.layer.cornerRadius = 5
        assistButton.layer.borderWidth = 1
        assistButton.layer.borderColor = UIColor.white.cgColor
        //Configure photosLabel aspect
        photosLabel.layer.cornerRadius = 5
        photosLabel.layer.borderWidth = 1
        photosLabel.layer.borderColor = UIColor.white.cgColor
        //Configure event name
        eventNameLabel.text = event?.name
        
        //Configure constraints depending on device orientation
        if UIDevice.current.orientation.isPortrait {
            self.configurePortrait()
        } else {
            self.configureLandscape()
        }
        
        self.navigationController?.navigationBar.tintColor = .white
        
        //register cell
        let nibCell = UINib(nibName: eventDetailCollectionViewCellId, bundle: nil)
        detailCollectionView.register(nibCell, forCellWithReuseIdentifier: eventDetailCollectionViewCellId)
        
        self.detailCollectionView.delegate = self
        self.detailCollectionView.dataSource = self
        detailCollectionView.reloadData()
        
        self.locationManager.delegate = self
        self.eventMap.delegate = self
        
        //Center map to event location
        if let latitude = event?.latitude, let longitude = event?.longitude {
            let center = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 0, longitudinalMeters: 250)
            eventMap.setRegion(region, animated: true)
        }
        
        //Configure share button
        self.configureShare()
        
    }
    
    func configureShare() {
        var shareButton: UIBarButtonItem = UIBarButtonItem()
        shareButton = UIBarButtonItem(title: "Compartir", style: .plain, target: self, action: #selector(shareTapped))
        shareButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem = shareButton
    }
    
    func configurePortrait() {
        //Ajust height constraints
        self.detailCollectionView.heightAnchor.constraint(equalToConstant: (250 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        self.eventDesTextView.heightAnchor.constraint(equalToConstant: (150 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        self.detailScrollView.heightAnchor.constraint(equalToConstant: (752 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        self.assistButton.heightAnchor.constraint(equalToConstant: (40 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        self.photosLabel.heightAnchor.constraint(equalToConstant: (30 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
    }
    
    func configureLandscape() {
        self.detailCollectionView.heightAnchor.constraint(equalToConstant: (250 * (detailCollectionView.bounds.width)) / 404 ).isActive = true
        self.eventDesTextView.heightAnchor.constraint(equalToConstant: (150 * (detailCollectionView.bounds.width)) / 404 ).isActive = true
        self.detailScrollView.heightAnchor.constraint(equalToConstant: (752 * (detailCollectionView.bounds.width)) / 404 ).isActive = true
        self.assistButton.heightAnchor.constraint(equalToConstant: (40 * (detailCollectionView.bounds.width)) / 404 ).isActive = true
        self.photosLabel.heightAnchor.constraint(equalToConstant: (30 * (detailCollectionView.bounds.width)) / 404 ).isActive = true
    }

    @IBAction func assistButtonPress(_ sender: UIButton) {
        if assistButton.isSelected {
            assistButton.setTitleColor(.white, for: .normal)
            assistButton.backgroundColor = .gray
            assistButton.isSelected = false
        } else {
            assistButton.setTitleColor(.black, for: .normal)
            assistButton.backgroundColor = .green
            assistButton.isSelected = true
        }
    }
    
    @objc func shareTapped() {
        //TODO decide what to share
        if let textToShare = event?.name,
           let website = NSURL(string: "https://4events.net") {
            let objectsToShare = [textToShare, website] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //Configure constraints depending on device orientation
        if UIDevice.current.orientation.isPortrait {
            let sizePortrait = CGSize(width: (UIScreen.main.bounds.width), height: (250 * (UIScreen.main.bounds.width)) / 414 )
            detailCollectionView.contentSize = sizePortrait
            self.configurePortrait()
        } else {
            let sizeLandscape = CGSize(width: (detailCollectionView.bounds.width)/2, height: (250 * (detailCollectionView.bounds.width + 20)/2) / 404 )
            detailCollectionView.contentSize = sizeLandscape
            self.configureLandscape()
        }
    }
}
