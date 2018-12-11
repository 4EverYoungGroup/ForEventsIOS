//
//  SearchDetailViewController+TableViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 09/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Global.eventTypesCheckSearch?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = eventTypeTableViewCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EventTypeTableViewCell
        let eventTypeCheck: EventTypeCheck = Global.eventTypesCheckSearch![indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = .black
        cell.eventTypeLabel.textColor = .white
        for i in 0..<self.evenTypesArray.count {
            if eventTypeCheck.id == self.evenTypesArray[i] {
                cell.accessoryType = .checkmark
                break
            } else {
                cell.accessoryType = .none
            }
        }
        
        cell.refresh(eventTypeCheck: eventTypeCheck, index: indexPath.row)
        return cell
    }
    
}
