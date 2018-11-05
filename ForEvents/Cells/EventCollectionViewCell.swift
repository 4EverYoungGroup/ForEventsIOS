//
//  EventCollectionViewCell.swift
//  ForEvents
//
//  Created by luis gomez alonso on 01/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    var event: Event?

    @IBOutlet weak var eventLabelCell: UILabel!
    @IBOutlet weak var eventImageCell: UIImageView!
    
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
        switch index {
        case 0:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "events")
        case 1:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "admission")
        case 2:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "cheers")
        case 3:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "hot-air-balloons")
        case 4:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "marathon")
        case 5:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "piano")
        case 6:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "reiter")
        case 7:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "theater")
        case 8:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "fireworks")
        default:
            self.eventImageCell.image = UIImage.init(imageLiteralResourceName: "events")
        }
        
        
    }

}
