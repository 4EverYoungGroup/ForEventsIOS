//
//  SearchDetailViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 09/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation

class SearchDetailViewController: UIViewController {

    var onDoneBlock : ((Bool) -> Void)?
    
    var evenTypesArray: [String] = []
    var latitude: String = ""
    var longitude: String = ""
    var radio: String = ""
    var radioInt: Int = 0
    let eventTypeTableViewCellId = "EventTypeTableViewCell"
    
    @IBOutlet weak var searchNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var queryTextLabel: UILabel!
    @IBOutlet weak var eventTypeTableView: UITableView!
    @IBOutlet weak var radioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibCell = UINib(nibName: eventTypeTableViewCellId, bundle: nil)
        eventTypeTableView.register(nibCell, forCellReuseIdentifier: eventTypeTableViewCellId)
        
        //Recover eventTypes
        ExecuteInteractorImpl().execute {
            eventTypesDownload()
        }
        
        //Recover searches params
        self.recoverSearchesParams()
        
    }


    @IBAction func findPress(_ sender: UIButton) {
        //Send find prameters selected notifications for update event collectionView
        if let radio = Int(radio) {
            radioInt = radio
        } else {
            radioInt = 1000
        }
        Global.findParamsDict = [
            "position": [Float(latitude), Float(longitude)],
            "queryText": self.queryTextLabel.text as Any,
            "eventTypes": self.evenTypesArray,
            "distance": radioInt] as Dictionary
        let notificationCenter = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: FindDidPressNotificationName), object: nil, userInfo: [FindKey: Global.findParamsDict ])
        self.dismiss(animated: true) {
            notificationCenter.post(notification)
            self.onDoneBlock!(true)
        }
    }
    @IBAction func cancelPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func recoverSearchesParams() {
        //recover searches parameters
        if let locations: String = Global.searchParamsDict["location"] as? String {
            let latLongRadio = locations.components(separatedBy: ",")
            self.latitude = latLongRadio[0]
            self.longitude = latLongRadio[1]
            //Obtain city from location
            let location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
            fetchCityAndCountry(from: location) { city, province, error in
                guard let city = city, let province = province, error == nil else { return }
                self.cityNameLabel.text = "\(city)/\(province)"
                Global.citySelectedName = self.cityNameLabel.text
            }
            
            self.radio = latLongRadio[2]
            self.radioLabel.text = "\(Int(radio)!/1000) Kms"
            
        }
        self.queryTextLabel.text = (Global.searchParamsDict["queryText"] as! String)
        if let eventTypes: String = Global.searchParamsDict["event_type"] as? String {
            evenTypesArray = eventTypes.components(separatedBy: ",")
        }
        self.searchNameLabel.text = (Global.searchParamsDict["name"] as! String)

    }
    
    func eventTypesDownload() {
        let downloadEventTypesInteractor: DownloadEventTypesInteractor = DownloadEventTypesInteractorNSURLSessionImpl()
        
        downloadEventTypesInteractor.execute { (eventTypes: [EventType]?) in
            // Todo OK
            if eventTypes != nil {
                for eventT in eventTypes! {
                    let eventTypesCheck = EventTypeCheck(id: eventT.id!, name: eventT.name, check: true)
                    Global.eventTypesCheckSearch?.append(eventTypesCheck)
                }
            }
            
            self.eventTypeTableView.delegate = self
            self.eventTypeTableView.dataSource = self
            self.eventTypeTableView.reloadData()
            
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ province:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.subAdministrativeArea,
                       error)
        }
    }
    
}
