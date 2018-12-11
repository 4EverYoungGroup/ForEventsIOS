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
        if tableView == eventTypeTableView {
            return (Global.eventTypesCheck?.count)!
        } else {
            return (Constants.distances.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == eventTypeTableView {
            let identifier = eventTypeTableViewCellId
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EventTypeTableViewCell
            let eventTypeCheck: EventTypeCheck = Global.eventTypesCheck![indexPath.row]
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if self.arrayEventTypes != nil {
                for event in self.arrayEventTypes! {
                    if event == eventTypeCheck.id {
                        cell.accessoryType = .checkmark
                        break
                    } else {
                        cell.accessoryType = .none
                    }
                }
            }
            
            cell.refresh(eventTypeCheck: eventTypeCheck, index: indexPath.row)
            return cell
        } else {
            let identifier = distanceTableViewCellId
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DistanceTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.refresh(distance: Constants.distances[indexPath.row], index: indexPath.row)
            if self.radio == Constants.distances[indexPath.row] {
                cell.accessoryType = .checkmark
                Global.distanceInMetres = Constants.distances[indexPath.row] * 1000
                let indexPath = NSIndexPath(row: indexPath.row, section: 0)
                distanceTableView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: .none)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == eventTypeTableView {
            let cell = tableView.cellForRow(at: indexPath) as! EventTypeTableViewCell
            let index = Global.eventTypesCheck?.index(where: {$0.name == cell.eventTypeLabel.text})
            Global.eventTypesCheck![index!].check = false
            cell.accessoryType = .none
            tableView.rectForRow(at: indexPath)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! DistanceTableViewCell
            cell.accessoryType = .checkmark
            let distanceKms = Int(cell.distanceLabel.text!) ?? 1
            Global.distanceInMetres = distanceKms * 1000
            tableView.rectForRow(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == eventTypeTableView {
            let cell = tableView.cellForRow(at: indexPath) as! EventTypeTableViewCell
            let index = Global.eventTypesCheck?.index(where: {$0.name == cell.eventTypeLabel.text})
            Global.eventTypesCheck![index!].check = true
            cell.accessoryType = .checkmark
            tableView.rectForRow(at: indexPath)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! DistanceTableViewCell
            cell.accessoryType = .none
            tableView.rectForRow(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView != eventTypeTableView {
            if indexPath.row == 0 && cell.isSelected == true {
                cell.accessoryType = .checkmark
            }
        }
    }
}

