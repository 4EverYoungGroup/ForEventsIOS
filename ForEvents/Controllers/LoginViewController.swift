//
//  LoginViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    var tokenItems: [KeychainTokenItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        //Gesture to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Put username in userTextField
        if let username = UserDefaults.standard.value(forKey: Constants.useremail) {
            self.userTextField.text = username as? String
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPress(_ sender: UIButton) {
        if self.validateLogin() {
            //Configure activity indicator
            view.addSubview(activityIndicator)
            activityIndicator.frame = view.bounds
            activityIndicator.style = .whiteLarge
            activityIndicator.startAnimating()
            
            ExecuteInteractorImpl().execute {
                loginUser()
            }
        }
    }
    
    @IBAction func recoverButtonPress(_ sender: UIButton) {
        if self.validateRecover() {
            //Configure activity indicator
            view.addSubview(activityIndicator)
            activityIndicator.style = .whiteLarge
            activityIndicator.frame = view.bounds
            activityIndicator.startAnimating()
            
            ExecuteInteractorImpl().execute {
                recoverUser()
            }
        }
    }
    
    func validateLogin() -> Bool {
        //email format validate
        if !(userTextField.text?.isValidEmail())! {
            let alert = Alerts().alert(title: Constants.loginTitle, message: "El dato de email debe de ser un correo electrónico válido.")
            self.userTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        //passwords is valid, must include uppercase, lowercase and digits and 6 long min
        if (passwordTextField.text?.isEmpty)! {
            let alert = Alerts().alert(title: Constants.loginTitle, message: "La password es obligatoria.")
            self.passwordTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateRecover() -> Bool {
        //email format validate
        if !(userTextField.text?.isValidEmail())! {
            let alert = Alerts().alert(title: Constants.loginTitle, message: "El dato de usuario debe de ser un email válido.")
            self.userTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func loginUser() {
        let userLogin = UserLogin(email: userTextField.text!, password: passwordTextField.text!, token: nil, user: nil)
        let loginUserInteractor: LoginUserInteractor = LoginUserInteractorNSURLSessionImpl()
        
        loginUserInteractor.execute(user: userLogin) { (userLogin: UserLogin?, responseApi: ResponseApi?) in
            if userLogin == nil {
                guard let message = responseApi!.message else { return }
                let alert = Alerts().alert(title: Constants.loginTitle, message: message)
                self.userTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            } else {
                //Save token in keychain
                if let token: String = userLogin?.token {
                    self.saveTokenInKeychain(token: token)
                    //Save useremail, userID, username and radio in usersdefaults
                    UserDefaults.standard.setValue(self.userTextField.text, forKey: Constants.useremail)
                    UserDefaults.standard.setValue(userLogin?.user?.id, forKey: Constants.userID)
                    UserDefaults.standard.setValue(userLogin?.user?.firstName, forKey: Constants.userFirstName)
                    UserDefaults.standard.setValue(userLogin?.user?.lastName, forKey: Constants.userLastName)
                    let radio = UserDefaults.standard.bool(forKey: Constants.radio)
                    if !radio {
                        UserDefaults.standard.setValue(1, forKey: Constants.radio)
                    }
                    //Save user position from favorite city
                    if userLogin?.user?.city != nil {
                   
                        UserDefaults.standard.set(true, forKey: "hasCity")
                        Global.citiesSelected?.append((userLogin?.user?.city)!)
                    UserDefaults.standard.setValue(userLogin?.user?.city?.location.coordinates[1], forKey: Constants.latitudeFavorite)
                    UserDefaults.standard.setValue(userLogin?.user?.city?.location.coordinates[0], forKey: Constants.longitudeFavorite)
                        let cityName = "\(userLogin?.user?.city?.city ?? "")/\(userLogin?.user?.city?.province ?? "")"
                        UserDefaults.standard.setValue(cityName, forKey: Constants.cityNameFavorite)
                    } else {
                        //Validate location Authorization
                        self.validateLocationAuthorization()
                    }
                    ExecuteInteractorImpl().execute {
                        self.updateTokenDeviceUser()
                    }
                }
            }
        }
    }
    
    func recoverUser() {
        let userLogin = UserLogin(email: userTextField.text!, password: nil, token: nil, user: nil)
        let recoverUserInteractor: RecoverUserInteractor = RecoverUserInteractorNSURLSessionImpl()
        
        recoverUserInteractor.execute(user: userLogin) { (responseApi: ResponseApi?) in
            if responseApi == nil {
                let message = "Se le ha enviado un email para recuperar su password."
                let alert = Alerts().alert(title: Constants.loginTitle, message: message)
                self.userTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            } else {
                guard let message = responseApi!.message else { return }
                let alert = Alerts().alert(title: Constants.loginTitle, message: message)
                self.userTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateTokenDeviceUser() {
        
        let saveTokenDeviceInUserInteractor: SaveTokenDeviceInUserInteractor = SaveTokenDeviceInUserInteractorNSURLSessionImpl()
        
        saveTokenDeviceInUserInteractor.execute() { (responseApi: ResponseApi?) in
            if responseApi == nil {
                //Go to Events tabBar
                let eventsTabBarController = createEventsTabBar()
                //Configure tabbar opaque and black
                eventsTabBarController.tabBar.isOpaque = true
                eventsTabBarController.tabBar.barTintColor = .black
                UIApplication.shared.keyWindow?.rootViewController = eventsTabBarController
            } else {
                if let message = responseApi?.message {
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let message = responseApi!.errors![0].message else { return }
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func saveTokenInKeychain(token: String) {
        //Save Token and user defaults with haslogin and username
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
        UserDefaults.standard.setValue(userTextField.text, forKey: "username")
        
        do {
            // Create a new keychain item with the token.
            let tokenItem = KeychainTokenItem(service: KeychainConfiguration.serviceName,
                                              account: userTextField.text!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save token for the new item.
            try tokenItem.saveToken(token)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK Location
    func validateLocationAuthorization() {
        
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            //locationManager.startUpdatingLocation()
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Localización no disponible", message: "Por favor, habilite la localización en Ajustes", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.delegate = self
            //locationManager.startUpdatingLocation()
            UserDefaults.standard.setValue(true, forKey: Constants.locationAuth)
            //self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        Global.citySelectedPosition = []
        Global.citySelectedPosition?.append(Float(currentLocation.coordinate.latitude))
        Global.citySelectedPosition?.append(Float(currentLocation.coordinate.longitude))
        manager.stopUpdatingLocation()
        manager.delegate = nil
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
            if UserDefaults.standard.bool(forKey: Constants.locationAuth) == false {
                UserDefaults.standard.setValue(true, forKey: Constants.locationAuth)
            }
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            if UserDefaults.standard.bool(forKey: Constants.locationAuth) == false {
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
}
