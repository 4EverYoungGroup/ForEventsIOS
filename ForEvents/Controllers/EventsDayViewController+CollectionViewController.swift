//
//  EventsDayViewController+CollectionViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 20/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

extension EventsDayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventsDaySelect.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = eventCollectionViewCellId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! EventCollectionViewCell
        let event: Event = self.eventsDaySelect[indexPath.row]
        cell.refresh(event: event, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventDetailViewController = EventDetailViewController()
        let event: Event = self.eventsDaySelect[indexPath.row]
        eventDetailViewController.event = event
        
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            return CGSize(width: (UIScreen.main.bounds.width - 40), height: (250 * (UIScreen.main.bounds.width - 40)) / 300 )
        } else {
            return CGSize(width: (UIScreen.main.bounds.width - 150)/2, height: (250 * (UIScreen.main.bounds.width - 150)/2) / 300 )
        }
    }
    
}
