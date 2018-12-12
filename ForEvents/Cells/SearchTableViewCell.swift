//
//  SearchTableViewCell.swift
//  ForEvents
//
//  Created by luis gomez alonso on 16/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTextLabel: UILabel!
    @IBOutlet weak var dateSearchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refresh(search: Search, index: Int) {
        self.searchTextLabel.text = search.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateSearchLabel.text = "\(dateFormatter.string(from: search.createDate))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
