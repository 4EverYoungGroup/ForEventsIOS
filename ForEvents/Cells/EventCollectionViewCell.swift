//
//  EventCollectionViewCell.swift
//  ForEvents
//
//  Created by luis gomez alonso on 01/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import Kingfisher

class EventCollectionViewCell: UICollectionViewCell {
    var event: Event?

    @IBOutlet weak var eventNameCell: UILabel!
    @IBOutlet weak var eventImageCell: UIImageView!
    @IBOutlet weak var eventDateCell: UILabel!
    @IBOutlet weak var eventCityCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventImageCell.layer.cornerRadius = 10
        eventImageCell.clipsToBounds = true
        eventImageCell.layer.borderWidth = 3
        eventImageCell.layer.borderColor = UIColor.white.cgColor
    }
    
    func refresh(event: Event, index: Int) {
        self.event = event
        
        self.eventNameCell.text = event.name
        if event.images.isEmpty == false {
            let url = URL(string: event.images[0])
            eventImageCell.kf.setImage(with: url)
        } else {
            let url = URL(string: "https://cdn.pixabay.com/photo/2017/11/24/10/43/admission-2974645_960_720.jpg")
            eventImageCell.kf.setImage(with: url)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        if let date = event.beginDate {
            let day = formatter.string(from: date)
            self.eventDateCell.text = "\(day) h"
        } else {
            let day = ""
            self.eventDateCell.text = "\(day) h"
        }
        self.eventCityCell.text = event.city
        //if event.free == true {
        //    self.eventFreeCell.text = "Entrada libre"
        //} else {
        //    self.eventFreeCell.text = "\(String(format: "%.02f€", event.price!))"
        //}
        //self.eventTypeCell.text = event.eventType
    }
}
