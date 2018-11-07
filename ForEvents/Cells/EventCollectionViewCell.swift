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
        event.images?[0].loadImage(into: eventImageCell)
        
    }

}
