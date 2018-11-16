//
//  Assists2ViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 16/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class AssistsViewController: UIViewController {
    
    var events: Events?
    
    @IBOutlet weak var assistsCollectionView: UICollectionView!
    
    let eventCollectionViewCellId = "EventCollectionViewCell"
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Asistencias"
        view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        let nibCell = UINib(nibName: eventCollectionViewCellId, bundle: nil)
        assistsCollectionView.register(nibCell, forCellWithReuseIdentifier: eventCollectionViewCellId)
        
        ExecuteInteractorImpl().execute {
            assistsDownload()
        }
        
        func assistsDownload() {
            let downloadEventsInteractor: DownloadEventsInteractor = DownloadAssistsInteractorFakeImpl()
            
            downloadEventsInteractor.execute { (events: Events) in
                // Todo OK
                self.events = events
                
                self.assistsCollectionView.collectionViewLayout.invalidateLayout()
                self.assistsCollectionView.delegate = self
                self.assistsCollectionView.dataSource = self
                self.assistsCollectionView.reloadData()
                
            }
        }
        
    }
    
}



