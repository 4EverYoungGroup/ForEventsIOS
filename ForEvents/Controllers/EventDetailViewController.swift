//
//  EventDetailViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 05/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    var event: Event?
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch event!.name {
        case "Evento número 0":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "events")
        case "Evento número 1":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "admission")
        case "Evento número 2":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "cheers")
        case "Evento número 3":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "hot-air-balloons")
        case "Evento número 4":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "marathon")
        case "Evento número 5":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "piano")
        case "Evento número 6":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "reiter")
        case "Evento número 7":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "theater")
        case "Evento número 8":
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "fireworks")
        default:
            self.eventImageView.image = UIImage.init(imageLiteralResourceName: "events")
        }
    }

}
