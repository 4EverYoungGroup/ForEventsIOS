//
//  FilterViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 05/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import SearchTextField

class FindViewController: UIViewController {

    @IBOutlet weak var eventTypeTableView: UITableView!
    @IBOutlet weak var km5Button: UIButton!
    @IBOutlet weak var km10Button: UIButton!
    @IBOutlet weak var km25Button: UIButton!
    @IBOutlet weak var km50Button: UIButton!
    @IBOutlet weak var km100Button: UIButton!
    @IBOutlet weak var cityTextField: SearchTextField!
    @IBOutlet weak var positionSwitchControl: UISwitch!
    @IBOutlet weak var queryTextField: UITextField!
    let eventTypeTableViewCellId = "EventTypeTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure search text field
        self.configureSearchTextField()
        
        //Configure km buttons
        self.configureKmsButtons()
        
        //Configure activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        let nibCell = UINib(nibName: eventTypeTableViewCellId, bundle: nil)
        eventTypeTableView.register(nibCell, forCellReuseIdentifier: eventTypeTableViewCellId)
        
        if Global.eventTypesCheck?.count == 0 {
            ExecuteInteractorImpl().execute {
                eventTypesDownload()
            }
        } else {
            activityIndicator.removeFromSuperview()
            self.eventTypeTableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                for city in cities! {
                    citiesNames.append(city.city+" "+city.province!)
                }
                // Set new items to filter
                self.cityTextField.filterStrings(citiesNames)
                
                // Stop loading indicator
                self.cityTextField.stopLoadingIndicator()
            }
        }
    }

    @IBAction func findButtonPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func km5ButtonPress(_ sender: UIButton) {
        self.setCheckButton(button: sender)
    }
    
    @IBAction func km10ButtonPress(_ sender: UIButton) {
        self.setCheckButton(button: sender)
    }
    
    @IBAction func km25ButtonPress(_ sender: UIButton) {
        self.setCheckButton(button: sender)
    }
    
    @IBAction func km50ButtonPress(_ sender: UIButton) {
        self.setCheckButton(button: sender)
    }
    
    @IBAction func km100ButtonPress(_ sender: UIButton) {
        self.setCheckButton(button: sender)
    }
    
    func configureKmsButtons() {
        km5Button.layer.borderWidth = 1
        km5Button.layer.borderColor = UIColor.black.cgColor
        km10Button.layer.borderWidth = 1
        km10Button.layer.borderColor = UIColor.black.cgColor
        km25Button.layer.borderWidth = 1
        km25Button.layer.borderColor = UIColor.black.cgColor
        km50Button.layer.borderWidth = 1
        km50Button.layer.borderColor = UIColor.black.cgColor
        km100Button.layer.borderWidth = 1
        km100Button.layer.borderColor = UIColor.black.cgColor
        if case let radio as Int = UserDefaults.standard.value(forKey: Constants.radio) {
            if radio == km5Button.tag {
                km5Button.setImage(UIImage(named: "checkMark"), for: .normal)
            }
            if radio == km10Button.tag {
                km10Button.setImage(UIImage(named: "checkMark"), for: .normal)
            }
            if radio == km25Button.tag {
                km25Button.setImage(UIImage(named: "checkMark"), for: .normal)
            }
            if radio == km50Button.tag {
                km50Button.setImage(UIImage(named: "checkMark"), for: .normal)
            }
            if radio == km100Button.tag {
                km100Button.setImage(UIImage(named: "checkMark"), for: .normal)
            }
        }
    }
    
    func setCheckButton(button: UIButton) {
        switch button.tag {
        case 5:
            button.setImage(UIImage(named: "checkMark"), for: .normal)
            km10Button.setImage(nil, for: .normal)
            km25Button.setImage(nil, for: .normal)
            km50Button.setImage(nil, for: .normal)
            km100Button.setImage(nil, for: .normal)
        case 10:
            button.setImage(UIImage(named: "checkMark"), for: .normal)
            km5Button.setImage(nil, for: .normal)
            km25Button.setImage(nil, for: .normal)
            km50Button.setImage(nil, for: .normal)
            km100Button.setImage(nil, for: .normal)
        case 25:
            button.setImage(UIImage(named: "checkMark"), for: .normal)
            km5Button.setImage(nil, for: .normal)
            km10Button.setImage(nil, for: .normal)
            km50Button.setImage(nil, for: .normal)
            km100Button.setImage(nil, for: .normal)
        case 50:
            button.setImage(UIImage(named: "checkMark"), for: .normal)
            km5Button.setImage(nil, for: .normal)
            km10Button.setImage(nil, for: .normal)
            km25Button.setImage(nil, for: .normal)
            km100Button.setImage(nil, for: .normal)
        case 100:
            button.setImage(UIImage(named: "checkMark"), for: .normal)
            km5Button.setImage(nil, for: .normal)
            km10Button.setImage(nil, for: .normal)
            km25Button.setImage(nil, for: .normal)
            km50Button.setImage(nil, for: .normal)
        default:
            button.setImage(UIImage(named: "checkMark"), for: .normal)
            km10Button.setImage(nil, for: .normal)
            km25Button.setImage(nil, for: .normal)
            km50Button.setImage(nil, for: .normal)
            km100Button.setImage(nil, for: .normal)
        }
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
}
