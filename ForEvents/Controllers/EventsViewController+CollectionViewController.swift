//
//  EventsViewController+CollectionViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 01/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

extension EventsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let events = Global.events {
            return events.count()
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = eventCollectionViewCellId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! EventCollectionViewCell
        let event: Event = ((Global.events?.get(index: indexPath.row))!)
        cell.refresh(event: event, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventDetailViewController = EventDetailViewController()
        let event: Event = ((Global.events?.get(index: indexPath.row))!)
        eventDetailViewController.event = event
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            return CGSize(width: (UIScreen.main.bounds.width - 40), height: (230 * (UIScreen.main.bounds.width - 40)) / 300 )
        } else {
            return CGSize(width: (UIScreen.main.bounds.width - 120)/2, height: (230 * (UIScreen.main.bounds.width - 120)/2) / 300 )
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCollectionViewId, for: indexPath) as! SectionHeaderCollectionReusableView
        
        if Global.citySelectedName != nil {
            header.headerLabel.text = "EVENTOS de \(Global.citySelectedName ?? "")"
        } else {
            header.headerLabel.text = "EVENTOS de su posición"
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}
