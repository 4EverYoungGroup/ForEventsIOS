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

    @IBOutlet weak var eventLabelCell: UILabel!
    @IBOutlet weak var eventImageCell: UIImageView!
    @IBOutlet weak var eventDateCell: UILabel!
    
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
        
        self.eventLabelCell.text = event.name
        let url = URL(string: event.images[0])
        eventImageCell.kf.setImage(with: url)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        if let date = event.eventDate {
            let day = formatter.string(from: date)
            self.eventDateCell.text = "\(day) h"
        } else {
            let day = ""
            self.eventDateCell.text = "\(day) h"
        }
    }
}
