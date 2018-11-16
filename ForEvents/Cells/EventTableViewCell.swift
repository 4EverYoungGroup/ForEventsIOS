//
//  EventTableViewCell.swift
//  ForEvents
//
//  Created by luis gomez alonso on 16/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewCell.layer.cornerRadius = 10
        imageViewCell.clipsToBounds = true
        imageViewCell.layer.borderWidth = 3
        imageViewCell.layer.borderColor = UIColor.white.cgColor
    }
    
    func refresh(event: Event, index: Int) {
        self.labelCell.text = event.name
        let url = URL(string: event.images[0])
        self.imageViewCell.kf.setImage(with: url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
