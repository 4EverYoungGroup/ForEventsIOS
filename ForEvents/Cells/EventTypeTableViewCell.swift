//
//  EventTypeTableViewCell.swift
//  ForEvents
//
//  Created by luis gomez alonso on 27/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class EventTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var eventTypeButton: UIButton!
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func refresh(eventTypeCheck: EventTypeCheck, index: Int) {
        self.eventTypeLabel.text = eventTypeCheck.name
        /*if eventTypeCheck.check {
            self.eventTypeButton.setImage(UIImage(named: "checkMark"), for: .selected)
            self.eventTypeButton.isSelected = true
        } else {
            self.eventTypeButton.setImage(nil, for: .normal)
            self.eventTypeButton.isSelected = false
        }*/
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
