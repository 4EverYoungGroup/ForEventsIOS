//
//  PreferencesViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 20/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    @IBOutlet weak var eventTypesTableView: UITableView!
    @IBOutlet weak var distancesTableView: UITableView!
    
    let eventTypeTableViewCellId = "EventTypeTableViewCell"
    let distanceTableViewCellId = "DistanceTableViewCell"
    let radio: Int? = (UserDefaults.standard.value(forKey: Constants.radio) as! Int)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Preferencias"
        view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register nib
        let nibCell = UINib(nibName: eventTypeTableViewCellId, bundle: nil)
        eventTypesTableView.register(nibCell, forCellReuseIdentifier: eventTypeTableViewCellId)
        let nibCellD = UINib(nibName: distanceTableViewCellId, bundle: nil)
        distancesTableView.register(nibCellD, forCellReuseIdentifier: distanceTableViewCellId)
        
        //Recover eventTypes
        ExecuteInteractorImpl().execute {
            eventTypesDownload()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Mark the distance preferred by the user, default first
        if (radio == nil) {
            let indexPath = NSIndexPath(row: 0, section: 0)
            distancesTableView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: .none)
        }
    }
    
    @IBAction func saveButtonPress(_ sender: UIButton) {
        //recoger eventtypes marcados
        guard let arrayEventTypes = Global.eventTypesCheckPref?.filter({$0.check == true}) else { return }
        if arrayEventTypes.count == 0 {
            let alert = Alerts().alert(title: Constants.preferenceTitle, message: "Debe de seleccionar al menos una categoría.")
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            let arrayEventTypesString = arrayEventTypes.map({ (element) -> String in
                return element.id
            })
            UserDefaults.standard.setValue(arrayEventTypesString, forKey: Constants.eventTypesCheckPref)
        }
        let alert = Alerts().alert(title: Constants.preferenceTitle, message: "Preferencias de usuario guardadas correctamente.")
        self.present(alert, animated: true, completion: nil)
    }
    
    func eventTypesDownload() {
        let downloadEventTypesInteractor: DownloadEventTypesInteractor = DownloadEventTypesInteractorNSURLSessionImpl()
        
        downloadEventTypesInteractor.execute { (eventTypes: [EventType]?) in
            // Todo OK
            if eventTypes != nil {
                for eventT in eventTypes! {
                    let eventTypesCheck = EventTypeCheck(id: eventT.id!, name: eventT.name, check: true)
                    Global.eventTypesCheckPref?.append(eventTypesCheck)
                }
            }
            
            self.eventTypesTableView.delegate = self
            self.eventTypesTableView.dataSource = self
            self.eventTypesTableView.reloadData()
            
        }
    }

}
