//
//  ProfileViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import Parchment

class ProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    //Create UIImagePickerController
    let imagePicker = UIImagePickerController()
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userCity: UILabel!
    
    @IBOutlet weak var userLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title
        title = "Perfil"
        
        //Configure edit Button
        self.configureEditProfile()
        
        //Configure button circular
        userButton.layer.cornerRadius = 0.5 * userButton.bounds.size.width
        userButton.clipsToBounds = true
        
        //Recover userPhoto of userDefaults
        if let userPhoto = UserDefaults.standard.imageForKey(key: "userPhoto") {
            userButton.setBackgroundImage(userPhoto, for: .normal)
        }
        //Set user name and city
        self.userName.text = "\((UserDefaults.standard.value(forKey: Constants.userFirstName) as! String)) \((UserDefaults.standard.value(forKey: Constants.userLastName) as! String))"
        self.userCity.text = Global.citySelectedName
        
        //Set user location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        //Create PageMenu
        self.createPageMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Configure navigationBar opaque and black, status bar white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }

    @IBAction func userButtonPress(_ sender: UIButton) {
        
        if self.photoLibraryAvailabilityCheck() {
            createPhotosAlert()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    //MARK: - location delegate methods to determine user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                
                self.userLocation.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                self.locationManager.stopUpdatingLocation()
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.userLocation.text = ""
        self.locationManager.stopUpdatingLocation()
    }
    
    func createPageMenu() {
        
        //Add the viewcontrollers to pagemenu
        let firstViewController = AssistsViewController()
        let secondViewController = SearchesViewController()
        let thirdViewController = PreferencesViewController()
        let viewControllers = [firstViewController, secondViewController, thirdViewController]
        let pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        //Configure pagemenu
        pagingViewController.indicatorColor = CustomColors.orangeColor
        pagingViewController.textColor = CustomColors.orangeColor
        pagingViewController.selectedTextColor = .white
        pagingViewController.backgroundColor = .black
        pagingViewController.menuBackgroundColor = .black
        pagingViewController.font = UIFont(name: "AvenirNext-Medium", size: 15)!
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
    
    func configureEditProfile() {
        var editButton: UIBarButtonItem = UIBarButtonItem()
        let image = UIImage(named: "updateUser")?.withRenderingMode(.alwaysOriginal)
        editButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(editTapped))
        editButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editTapped() {
        let registerViewController = RegisterViewController()
        registerViewController.originCall = "update"
        navigationController?.pushViewController(registerViewController, animated: false)
    }
    
}


