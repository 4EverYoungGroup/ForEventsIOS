//
//  DistanceTableViewCell.swift
//  ForEvents
//
//  Created by luis gomez alonso on 28/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refresh(distance: Int, index: Int) {
        self.distanceLabel.text = String(distance)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
