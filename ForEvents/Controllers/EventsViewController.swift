//
//  EventsViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import CoreLocation

class EventsViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    let eventCollectionViewCellId = "EventCollectionViewCell"
    let headerCollectionViewId = "SectionHeader"
    
    let locationManager = CLLocationManager()
    
    var filterButton: UIBarButtonItem = UIBarButtonItem()
    var startButtonOff: UIBarButtonItem = UIBarButtonItem()
    var startButtonOn: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        //Set title
        title = "Eventos"
        //Add to notification FindDidPress
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(findDidChange), name: NSNotification.Name(rawValue: FindDidPressNotificationName), object: nil)
        
        //Configure logout Button
        self.configureLogout()
        //Configure find Button
        self.configureFindAndStart()
        
        //If user has favorite city start with them
        if UserDefaults.standard.bool(forKey: Constants.hasCity) == true {
            if let latitudeFavorite: Float = UserDefaults.standard.value(forKey: Constants.latitudeFavorite) as? Float,
                let longitudeFavorite: Float = UserDefaults.standard.value(forKey: Constants.longitudeFavorite) as? Float,
                let cityNameFavorite: String = UserDefaults.standard.value(forKey: Constants.cityNameFavorite) as? String {
                Global.citySelectedPosition = []
                Global.citySelectedPosition?.append(latitudeFavorite)
                Global.citySelectedPosition?.append(longitudeFavorite)
                Global.citySelectedName = cityNameFavorite
                
            }
        }
        self.startEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Configure navigationBar opaque and black, status bar white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        //Reload events if assists button is press in detail
        eventsDownload(params: Global.findParamsDict as Dictionary<String, Any>)
    }
    
    deinit {
        //Delete notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    func startEvents() {
        //Configure activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.style = .whiteLarge
        activityIndicator.startAnimating()
        
        //register header
        eventsCollectionView.register(UINib(nibName: "SectionHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCollectionViewId)
        //register cell
        let nibCell = UINib(nibName: eventCollectionViewCellId, bundle: nil)
        eventsCollectionView.register(nibCell, forCellWithReuseIdentifier: eventCollectionViewCellId)
        
        ExecuteInteractorImpl().execute {
            //Recover radio in user default
            var radioInMeters: Int = 0
            if let radio = (UserDefaults.standard.value(forKey: Constants.radio) as? Int) {
                radioInMeters = radio * 1000
                Global.distanceInMetres = radioInMeters
            } else {
                radioInMeters = 1000
                Global.distanceInMetres = radioInMeters
            }
            //Pass self location or favorite city location
            Global.findParamsDict = [
                "position": Global.citySelectedPosition ?? [0,0],
                "queryText": nil,
                "eventTypes": nil,
                "distance": radioInMeters] as Dictionary
            eventsDownload(params: Global.findParamsDict as Dictionary<String, Any>)
        }
    }

    func eventsDownload(params: Dictionary<String, Any>) {
        let downloadEventsInteractor: DownloadEventsInteractor = DownloadEventsInteractorNSURLSessionImpl()
        
        downloadEventsInteractor.execute(params: params) { (events: Events) in
            // Todo OK
            Global.events = events
            Global.transactionIdLast = nil
            self.eventsCollectionView.delegate = self
            self.eventsCollectionView.dataSource = self
            self.eventsCollectionView.reloadData()
            //Alert with no events
            if events.count() == 0 {
                let alert = Alerts().alert(title: Constants.eventTitle, message: "De momento no tenemos eventos para esa búsqueda.")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func configureFindAndStart() {
        let image = UIImage(named: "find")?.withRenderingMode(.alwaysOriginal)
        filterButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(findTapped))
        
        let imageOff = UIImage(named: "start")?.withRenderingMode(.alwaysOriginal)
        startButtonOff = UIBarButtonItem(image: imageOff, style: .plain, target: self, action: #selector(startTappedOff))
        
        let imageOn = UIImage(named: "startFilled")?.withRenderingMode(.alwaysOriginal)
        startButtonOn = UIBarButtonItem(image: imageOn, style: .plain, target: self, action: #selector(startTappedOn))
        
        navigationItem.rightBarButtonItems = [filterButton, startButtonOff]
    }
    
    func configureLogout() {
        var logoutButton: UIBarButtonItem = UIBarButtonItem()
        let image = UIImage(named: "logoutUser")?.withRenderingMode(.alwaysOriginal)
        logoutButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(logoutTapped))
        logoutButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)!], for: .normal)
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func findTapped() {
        let filterViewController = FindViewController()
        filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: true, completion: nil)
    }
    
    @objc func startTappedOff() {
        showFavoriteSearchDialog(title: "4Events",
                                 subtitle: "Guardar búsqueda como favorita.",
                                 actionTitle: "Guardar",
                                 cancelTitle: "Cancelar",
                                 inputPlaceholder: "Nombre búsqueda",
                                 inputKeyboardType: .default)
        { (input:String?) in
            ExecuteInteractorImpl().execute {
                //Pass dictionary with find params and favoriteSearch name
                self.saveFavoriteSearch(params: Global.findParamsDict as Dictionary<String, Any>, name: input ?? "Sin nombre", action: Constants.favoriteSearchAdd, favoriteSearchId: nil)
            }
        }
    }
    
    @objc func startTappedOn() {
        //Delete favoriteSearch - Alert
        let deleteFavoriteSearchAlertController = UIAlertController (title: "Atención, ha solicitado borrar su búsqueda", message: "Esta acción borrará su búsqueda favorita.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Borrar", style: .destructive) { (_) -> Void in
            //Delete favoriteSearch
            ExecuteInteractorImpl().execute {
                //Pass favoriteSearchId
                self.saveFavoriteSearch(params: Global.findParamsDict as Dictionary<String, Any>, name: nil, action: Constants.favoriteSearchDelete, favoriteSearchId: Global.favoriteSearchIdLast)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        deleteFavoriteSearchAlertController .addAction(settingsAction)
        deleteFavoriteSearchAlertController .addAction(cancelAction)
        self.present(deleteFavoriteSearchAlertController, animated: true, completion: nil)
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
    
    func saveFavoriteSearch(params: Dictionary<String, Any>?, name: String?, action: String, favoriteSearchId: String?) {
        let favoriteSearchInteractor: FavoriteSearchInteractor = FavoriteSearchInteractorNSURLSessionImpl()
        
        favoriteSearchInteractor.execute(params: params, name: name, action: action, favoriteSearchId: favoriteSearchId) { (responseApi: ResponseApi?) in
            // Todo OK
            if responseApi == nil {
                if action == Constants.favoriteSearchAdd {
                    self.navigationItem.setRightBarButtonItems([self.filterButton, self.startButtonOn], animated: false)
                } else {
                    self.navigationItem.setRightBarButtonItems([self.filterButton, self.startButtonOff], animated: false)
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
    
    func logoutUser() {
        UserDefaults.standard.set(false, forKey: "hasLoginKey")
        UserDefaults.standard.removeObject(forKey: Constants.latitudeFavorite)
        UserDefaults.standard.removeObject(forKey: Constants.longitudeFavorite)
        UserDefaults.standard.removeObject(forKey: Constants.cityNameFavorite)
        UserDefaults.standard.set(false, forKey: "hasCity")
        let loginTabBarController = createLoginTabBar()
        //Show login in tabbar
        loginTabBarController.selectedIndex = 0
        //Configure tabbar without background and shadow
        loginTabBarController.tabBar.backgroundImage = UIImage()
        loginTabBarController.tabBar.shadowImage = UIImage()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginTabBarController
    }
    
    // Mark: - Notifications
    @objc func findDidChange(notification: Notification) {
        //Uncheck star if it was marked as search favorite
        self.navigationItem.setRightBarButtonItems([self.filterButton, self.startButtonOff], animated: false)
        //Recover findParameters
        let info = notification.userInfo!
        //extract the selected day
        let findParameters = info[FindKey]
        eventsDownload(params: findParameters as! Dictionary<String, Any>)
    }
    
    func showFavoriteSearchDialog(title:String? = nil,
                                  subtitle:String? = nil,
                                  actionTitle:String? = nil,
                                  cancelTitle:String? = nil,
                                  inputPlaceholder:String? = nil,
                                  inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                                  cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                  actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
