//
//  EventDetailViewController+CollectionViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 06/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

extension EventDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let event = self.event {
            let numPhotos = (event.images.count)
            if numPhotos == 1 {
                photosLabel.text = "\(numPhotos) Foto"
            } else {
                photosLabel.text = "\(numPhotos) Fotos"
            }
            return (event.images.count)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = eventDetailCollectionViewCellId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! EventDetailCollectionViewCell
        let event: Event = self.event!
        cell.refresh(event: event, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            return CGSize(width: (UIScreen.main.bounds.width), height: (250 * (UIScreen.main.bounds.width)) / 414 )
        } else {
            return CGSize(width: (collectionView.bounds.width + 20)/2, height: (250 * (collectionView.bounds.width)/2) / 404 )
        }
    }
}
