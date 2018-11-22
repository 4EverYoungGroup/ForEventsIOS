//
//  EventsDayViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 20/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class EventsDayViewController: UIViewController {
    
    var eventsDay: Date?
    var eventsDaySelect: [Event] = []

    @IBOutlet weak var eventsDayCollectionView: UICollectionView!
    
    let eventCollectionViewCellId = "EventCollectionViewCell"
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Eventos del día"
        view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: eventCollectionViewCellId, bundle: nil)
        eventsDayCollectionView.register(nibCell, forCellWithReuseIdentifier: eventCollectionViewCellId)
        
        //Add to notification daySelectedChange
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dayDidChange), name: Notification.Name(DayDidChangeNotificationName), object: nil)
        
        self.eventsDayDownload()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.eventsDayCollectionView.collectionViewLayout.invalidateLayout()
        self.eventsDayCollectionView.delegate = self
        self.eventsDayCollectionView.dataSource = self
        self.eventsDayCollectionView.reloadData()
    }
    
    deinit {
        //Delete notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    func eventsDayDownload() {
        self.eventsDaySelect = []
        let eventsG = Global.events
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let daySelected = formatter.string(from: eventsDay ?? Date())
        if let numberEvents = eventsG?.count() {
            for i in 0..<numberEvents {
                let event : Event = ((Global.events?.get(index: i))!)
                if let date = event.eventDate {
                    let day = formatter.string(from: date)
                    if day == daySelected {
                        self.eventsDaySelect.append(event)
                    }
                }
            }
        }
    }
    
    // Mark: - Notifications
    @objc func dayDidChange(notification: Notification) {
        self.eventsDayCollectionView.collectionViewLayout.invalidateLayout()
        //Recover dayselected in calendar
        let info = notification.userInfo!
        //extract the selected day
        let daySelected = info[DayKey] as? Date
        //Update daySelected
        self.eventsDay = daySelected
        //Sinchronize events
        self.eventsDayDownload()
        //Reload collectionView
        self.eventsDayCollectionView.reloadData()
    }
    
}
