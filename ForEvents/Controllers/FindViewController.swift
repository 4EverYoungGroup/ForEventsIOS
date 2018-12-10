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
    let radio: Int? = (UserDefaults.standard.value(forKey: Constants.radio) as! Int)
    let arrayEventTypes: [String]? = (UserDefaults.standard.value(forKey: Constants.eventTypesCheckPref) as! [String])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If user not auth location disabled position button
        if UserDefaults.standard.bool(forKey: Constants.locationAuth) == false {
            positionSwitchControl.isEnabled = false
        } else {
            locationManager.delegate = self
        }
        
        //Configure search text field
        configureSearchTextField(textField: cityTextField)
        
        //Configure activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.style = .whiteLarge
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
        
        //Mark the distance preferred by the user, default first
        if (radio == nil) {
            let indexPath = NSIndexPath(row: 0, section: 0)
            distanceTableView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: .none)
        }
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
            //If userdefault is empty from eventtypes inicialize with all
            if self.arrayEventTypes == nil {
                guard let arrayEventTypesCheck = Global.eventTypesCheck?.filter({$0.check == true}) else { return }
                let arrayEventTypes = arrayEventTypesCheck.map({ (element) -> String in
                    return element.id
                })
                UserDefaults.standard.setValue(arrayEventTypes, forKey: Constants.eventTypesCheckPref)
            }
            
            self.eventTypeTableView.delegate = self
            self.eventTypeTableView.dataSource = self
            self.eventTypeTableView.reloadData()
            
        }
    }

    @IBAction func findButtonPress(_ sender: UIButton) {
        //localidad - posición
        if !positionSwitchControl.isOn {
            //recoger posicion localidad
            if !self.validateCity() {
                let alert = Alerts().alert(title: Constants.findTitle, message: "Debe de seleccionar una localidad de la lista o su posición actual.")
                self.cityTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                Global.citySelectedName = self.cityTextField.text
            }
        } else {
            Global.citySelectedName = nil
        }
        //recoger eventtypes marcados
        guard let arrayEventTypes = Global.eventTypesCheck?.filter({$0.check == true}) else { return }
        if arrayEventTypes.count == 0 {
            let alert = Alerts().alert(title: Constants.findTitle, message: "Debe de seleccionar al menos una categoría.")
            self.present(alert, animated: true, completion: nil)
            return
        }
        //recoger texto
        guard let text = self.queryTextField.text else { return }
        //recoger radio
        //Send find prameters selected notifications for update event collectionView
        Global.findParamsDict = [
            "position": Global.citySelectedPosition ?? [0,0],
            "queryText": text,
            "eventTypes": arrayEventTypes,
            "distance": Global.distanceInMetres] as Dictionary
        let notificationCenter = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: FindDidPressNotificationName), object: nil, userInfo: [FindKey: Global.findParamsDict ])
        self.dismiss(animated: true) {
            notificationCenter.post(notification)
        }
    }
    
    @IBAction func cancelButtonPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func positionPress(_ sender: UISwitch) {
        if positionSwitchControl.isOn {
            cityTextField.isEnabled = false
            if CLLocationManager.locationServicesEnabled(){
                locationManager.delegate = self
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - location delegate methods to determine user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        Global.citySelectedPosition = []
        Global.citySelectedPosition?.append(Float(userLocation.coordinate.latitude))
        Global.citySelectedPosition?.append(Float(userLocation.coordinate.longitude))
    
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
    }
}
