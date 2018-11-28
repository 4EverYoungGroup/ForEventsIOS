//
//  FindViewController+TableViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 27/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

extension FindViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Global.eventTypesCheck?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = eventTypeTableViewCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EventTypeTableViewCell
        let eventTypeCheck: EventTypeCheck = Global.eventTypesCheck![indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if eventTypeCheck.check {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.refresh(eventTypeCheck: eventTypeCheck, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTypeTableViewCell
        let index = Global.eventTypesCheck?.index(where: {$0.name == cell.eventTypeLabel.text})
        Global.eventTypesCheck![index!].check = false
        cell.accessoryType = .none
        tableView.rectForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTypeTableViewCell
        let index = Global.eventTypesCheck?.index(where: {$0.name == cell.eventTypeLabel.text})
        Global.eventTypesCheck![index!].check = true
        cell.accessoryType = .checkmark
        tableView.rectForRow(at: indexPath)
    }
}

