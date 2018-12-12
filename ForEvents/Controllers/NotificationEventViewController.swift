//
//  NotificationEventViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 12/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class NotificationEventViewController: UIViewController {
    
    var eventId: String? = nil
    
    
    @IBOutlet weak var eventIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventIdLabel.text = eventId
        
        //Recover event
        if let event = eventId {
            ExecuteInteractorImpl().execute {
                self.eventDownload(eventId: event)
            }
        }
    }
    
    func eventDownload(eventId: String) {
        let downloadEventNotificationInteractor: DownloadEventNotificationInteractor = DownloadEventNotificationInteractorNSURLSessionImpl()
        
        downloadEventNotificationInteractor.execute(eventId: eventId) { (events: Events) in
            //OK
            if events.count() == 1 {
                //TODO Present event in screen
            }
        }
    }

    @IBAction func okNotificationPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
