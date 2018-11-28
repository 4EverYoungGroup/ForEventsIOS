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
    
    let eventTypeTableViewCellId = "EventTypeTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
