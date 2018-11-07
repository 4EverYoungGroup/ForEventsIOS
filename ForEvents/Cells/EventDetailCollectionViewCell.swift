//
//  EventDetailCollectionViewCell.swift
//  ForEvents
//
//  Created by luis gomez alonso on 06/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class EventDetailCollectionViewCell: UICollectionViewCell {
    var event: Event?

    @IBOutlet weak var eventDetailCollectionViewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Ajust height constraints
        self.eventDetailCollectionViewCell.heightAnchor.constraint(equalToConstant: (250 * (UIScreen.main.bounds.width)) / UIScreen.main.bounds.width ).isActive = true
        // Initialization code
        eventDetailCollectionViewCell.layer.cornerRadius = 10
        eventDetailCollectionViewCell.clipsToBounds = true
        eventDetailCollectionViewCell.layer.borderWidth = 3
        eventDetailCollectionViewCell.layer.borderColor = UIColor.white.cgColor
    }
    
    func refresh(event: Event, index: Int) {
        self.event = event
        
        event.images[index].loadImage(into: eventDetailCollectionViewCell)
        
    }

}
