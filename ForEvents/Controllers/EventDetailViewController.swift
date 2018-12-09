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
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDateEndLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventZipcodeLabel: UILabel!
    @IBOutlet weak var eventCityLabel: UILabel!
    @IBOutlet weak var eventProvinceLabel: UILabel!
    @IBOutlet weak var eventMaxVisitorsLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var eventMinAgeLabel: UILabel!
    @IBOutlet weak var outdoorIndoorImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDesTextView: UITextView!
    @IBOutlet weak var eventMap: MKMapView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    var event: Event?
    var assists: Bool = false
    
    let eventDetailCollectionViewCellId = "EventDetailCollectionViewCell"
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure assistButton aspect
        //assistButton.backgroundColor = .clear
        assistButton.layer.cornerRadius = 5
        assistButton.layer.borderWidth = 1
        assistButton.layer.borderColor = UIColor.white.cgColor
        //Configure photosLabel aspect
        photosLabel.layer.cornerRadius = 5
        photosLabel.layer.borderWidth = 1
        photosLabel.layer.borderColor = UIColor.white.cgColor
        
        //Save transactionId
        if event?.transactionId != nil {
            Global.transactionIdLast = event?.transactionId
        }
        //Configure event labels
        self.putLabelsText()
        
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
        
        ExecuteInteractorImpl().execute {
            if assistButton.isSelected {
                registerTransaction(action: Constants.transactionDelete)
            } else {
                registerTransaction(action: Constants.transactionAdd)
            }
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
    
    func putLabelsText() {
        eventNameLabel.text = event?.name
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        if let date = event?.beginDate {
            let day = formatter.string(from: date)
            self.eventDateLabel.text = "\(day) h"
        } else {
            let day = ""
            self.eventDateLabel.text = "\(day) h"
        }
        if let date = event?.endDate {
            let day = formatter.string(from: date)
            self.eventDateEndLabel.text = "\(day) h"
        } else {
            let day = ""
            self.eventDateEndLabel.text = "\(day) h"
        }
        self.eventAddressLabel.text = event?.address
        self.eventZipcodeLabel.text = event?.zipCode
        self.eventCityLabel.text = event?.city
        self.eventProvinceLabel.text = event?.province
        self.eventMaxVisitorsLabel.text = "\(event?.maxVisitors ?? 0)"
        if (event?.free)! {
            self.eventPriceLabel.text = "0"
        } else {
            self.eventPriceLabel.text = "\(Int((event?.price)!))"
        }
        self.eventMinAgeLabel.text = "\(event?.minAge ?? 0)"
        if (event?.indoor)! {
            self.outdoorIndoorImage.image = UIImage(named: "indoor")
        }
        self.eventDesTextView.text = event?.description
        //Put assistButton in green when previous is assists list
        if assists {
            self.assistButton.setTitleColor(.black, for: .normal)
            self.assistButton.backgroundColor = .green
            self.assistButton.isSelected = true
            self.assistButton.isEnabled = false
        } else {
            //Put assistButton in green if event has been pussed previously
            if event?.transactionId != nil {
                self.assistButton.setTitleColor(.black, for: .normal)
                self.assistButton.backgroundColor = .green
                self.assistButton.isSelected = true
            } else {
                self.assistButton.setTitleColor(.white, for: .normal)
                self.assistButton.backgroundColor = .gray
                self.assistButton.isSelected = false
            }
        }
    }
    
    func registerTransaction(action: String) {
        
        let eventId = self.event?.id
        
        let transactionInteractor: TransactionInteractor = TransactionInteractorNSURLSessionImpl()
        
        transactionInteractor.execute(action: action, eventId: eventId, transactionId: Global.transactionIdLast) { (responseApi: ResponseApi?) in
            if responseApi == nil {
                if self.assistButton.isSelected {
                    self.assistButton.setTitleColor(.white, for: .normal)
                    self.assistButton.backgroundColor = .gray
                    self.assistButton.isSelected = false
                } else {
                    self.assistButton.setTitleColor(.black, for: .normal)
                    self.assistButton.backgroundColor = .green
                    self.assistButton.isSelected = true
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
}
