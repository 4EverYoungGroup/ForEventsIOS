//
//  EventDetailViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 05/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBOutlet weak var assistButton: UIButton!
    
    @IBOutlet weak var photosLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventDesTextView: UITextView!
    
    @IBOutlet weak var eventMap: MKMapView!
    
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    var event: Event?
    
    let eventDetailCollectionViewCellId = "EventDetailCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure assistButton aspect
        //assistButton.backgroundColor = .clear
        assistButton.layer.cornerRadius = 5
        assistButton.layer.borderWidth = 1
        assistButton.layer.borderColor = UIColor.white.cgColor
        //Configure photosLabel aspect
        photosLabel.layer.cornerRadius = 5
        photosLabel.layer.borderWidth = 1
        photosLabel.layer.borderColor = UIColor.white.cgColor
        //Configure event name
        eventNameLabel.text = event?.name
        
        //Ajust height constraints
        self.detailCollectionView.heightAnchor.constraint(equalToConstant: (250 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        self.eventDesTextView.heightAnchor.constraint(equalToConstant: (150 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        self.eventMap.heightAnchor.constraint(equalToConstant: (200 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        self.detailScrollView.heightAnchor.constraint(equalToConstant: (752 * (UIScreen.main.bounds.width)) / 414 ).isActive = true
        
        self.navigationController?.navigationBar.tintColor = .white
        
        //register cell
        let nibCell = UINib(nibName: eventDetailCollectionViewCellId, bundle: nil)
        detailCollectionView.register(nibCell, forCellWithReuseIdentifier: eventDetailCollectionViewCellId)
        
        self.detailCollectionView.delegate = self
        self.detailCollectionView.dataSource = self
        detailCollectionView.reloadData()
    }

    @IBAction func assistButtonPress(_ sender: UIButton) {
        if assistButton.isSelected {
            assistButton.setTitleColor(.white, for: .normal)
            assistButton.backgroundColor = .gray
            assistButton.isSelected = false
        } else {
            assistButton.setTitleColor(.black, for: .normal)
            assistButton.backgroundColor = .green
            assistButton.isSelected = true
        }
    }
}
