//
//  FilterViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 05/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class FindViewController: UIViewController {

    @IBOutlet weak var eventTypeTableView: UITableView!
    @IBOutlet weak var km5Button: UIButton!
    @IBOutlet weak var km10Button: UIButton!
    @IBOutlet weak var km25Button: UIButton!
    @IBOutlet weak var km50Button: UIButton!
    @IBOutlet weak var km100Button: UIButton!
    
    let eventTypeTableViewCellId = "EventTypeTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
