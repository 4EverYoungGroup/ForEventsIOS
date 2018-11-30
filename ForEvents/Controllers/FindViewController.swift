//
//  FilterViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 05/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import SearchTextField
import CoreLocation

let FindDidPressNotificationName = "FindDidPress"
let FindKey = "FindKey"

class FindViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var eventTypeTableView: UITableView!
    @IBOutlet weak var distanceTableView: UITableView!
    @IBOutlet weak var cityTextField: SearchTextField!
    @IBOutlet weak var positionSwitchControl: UISwitch!
    @IBOutlet weak var queryTextField: UITextField!
    let eventTypeTableViewCellId = "EventTypeTableViewCell"
    let distanceTableViewCellId = "DistanceTableViewCell"
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        //Configure search text field
        self.configureSearchTextField()
        
        //Configure activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        let nibCell = UINib(nibName: eventTypeTableViewCellId, bundle: nil)
        eventTypeTableView.register(nibCell, forCellReuseIdentifier: eventTypeTableViewCellId)
        let nibCellD = UINib(nibName: distanceTableViewCellId, bundle: nil)
        distanceTableView.register(nibCellD, forCellReuseIdentifier: distanceTableViewCellId)
        
        if Global.eventTypesCheck?.count == 0 {
            ExecuteInteractorImpl().execute {
                eventTypesDownload()
            }
        } else {
            activityIndicator.removeFromSuperview()
            self.eventTypeTableView.reloadData()
        }
        
        //Configure radio distances
        self.distanceTableView.delegate = self
        self.distanceTableView.dataSource = self
        self.distanceTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        distanceTableView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: .none)
    }
    
    func eventTypesDownload() {
        let downloadEventTypesInteractor: DownloadEventTypesInteractor = DownloadEventTypesInteractorNSURLSessionImpl()
        
        downloadEventTypesInteractor.execute { (eventTypes: [EventType]?) in
            // Todo OK
            if eventTypes != nil {
                for eventT in eventTypes! {
                    let eventTypesCheck = EventTypeCheck(id: eventT.id!, name: eventT.name, check: true)
                    Global.eventTypesCheck?.append(eventTypesCheck)
                }
            }
            
            self.eventTypeTableView.delegate = self
            self.eventTypeTableView.dataSource = self
            self.eventTypeTableView.reloadData()
            
        }
    }
    
    func citiesDownload(queryText: String) {
        let citiesInteractor: GetCitiesInteractor = GetCitiesInteractorNSURLSessionImpl()
        
        citiesInteractor.execute(queryText: queryText) { (cities: [City]?) in
            // OK
            if cities != nil {
                //Create array with cities name result
                var citiesNames: [String] = []
                Global.citiesSelected = []
                for city in cities! {
                    citiesNames.append(city.city+"/"+city.province!)
                    Global.citiesSelected?.append(city)
                }
                // Set new items to filter
                self.cityTextField.filterStrings(citiesNames)
                
                // Stop loading indicator
                self.cityTextField.stopLoadingIndicator()
            }
        }
    }

    @IBAction func findButtonPress(_ sender: UIButton) {
        //localidad - posición
        if !positionSwitchControl.isOn {
            //recoger posicion localidad
            if !self.validateCity() {
                let alert = Alerts().alert(title: Constants.regTitle, message: "Debe de seleccionar una localidad de la lista o su posición actual.")
                self.cityTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        //recoger texto
        guard let text = self.queryTextField.text else { return }
        //recoger eventtypes marcados
        guard let arrayEventTypes = Global.eventTypesCheck?.filter({$0.check == true}) else { return }
        //recoger radio
        print(Global.distanceInMetres)
        //Send find prameters selected notifications for update event collectionView
        let findDict = [
            "position": Global.citySelectedPosition ?? [0,0],
            "queryText": text,
            "eventTypes": arrayEventTypes,
            "distance": Global.distanceInMetres] as Dictionary
        let notificationCenter = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: FindDidPressNotificationName), object: nil, userInfo: [FindKey: findDict ])
        self.dismiss(animated: true) {
            notificationCenter.post(notification)
        }
    }
    
    @IBAction func positionPress(_ sender: UISwitch) {
        if positionSwitchControl.isOn {
            cityTextField.isEnabled = false
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        } else {
            cityTextField.isEnabled = true
        }
    }
    
    func validateCity() -> Bool {
        let cityTextSelected = self.cityTextField.text?.components(separatedBy: "/")
        let citySelected = Global.citiesSelected?.filter({$0.city == cityTextSelected![0]})
        if (citySelected?.count)! == 1 {
            let city: City = citySelected![0]
            Global.citySelectedPosition = []
            Global.citySelectedPosition?.append(city.location.coordinates[1])
            Global.citySelectedPosition?.append(city.location.coordinates[0])
            return true
        }
        return false
    }
    
    fileprivate func configureSearchTextField() {
        cityTextField.startVisibleWithoutInteraction = false
        // Set a visual theme (SearchTextFieldTheme). By default it's the light theme
        cityTextField.theme = SearchTextFieldTheme.darkTheme()
        
        // Modify current theme properties
        cityTextField.theme.font = UIFont(name: "AvenirNext-Bold", size: 13)!
        cityTextField.theme.bgColor = .black
        cityTextField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        cityTextField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        cityTextField.theme.cellHeight = 50
        
        // Set specific comparision options - Default: .caseInsensitive
        cityTextField.comparisonOptions = [.caseInsensitive]
        
        // Handle item selection - Default behaviour: item title set to the text field
        cityTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            
            // Do whatever you want with the picked item
            self.cityTextField!.text = item.title
        }
        
        // Update data source when the user stops typing
        cityTextField.userStoppedTypingHandler = {
            if let criteria = self.cityTextField.text {
                if criteria.count > 2 {
                    
                    // Show loading indicator
                    self.cityTextField.showLoadingIndicator()
                    
                    self.citiesDownload(queryText: criteria)
                }
            }
        } as (() -> Void)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - location delegate methods to determine user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        Global.citySelectedPosition = []
        Global.citySelectedPosition?.append(Float(userLocation.coordinate.latitude))
        Global.citySelectedPosition?.append(Float(userLocation.coordinate.longitude))
    
        self.locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
    }
}
