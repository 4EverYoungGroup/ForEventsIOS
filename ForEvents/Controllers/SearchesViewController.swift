//
//  SearchesViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class SearchesViewController: UIViewController {
    
    @IBOutlet weak var searchesTableView: UITableView!
    
    let searchTableViewCellId = "SearchTableViewCell"
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Búsquedas"
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
        activityIndicator.style = .whiteLarge
        activityIndicator.startAnimating()
        
        let nibCell = UINib(nibName: searchTableViewCellId, bundle: nil)
        searchesTableView.register(nibCell, forCellReuseIdentifier: searchTableViewCellId)
        
        ExecuteInteractorImpl().execute {
            searchesDownload()
        }
        
    }
    
    func searchesDownload() {
        let downloadSearchesInteractor: DownloadSearchesInteractor = DownloadSearchesInteractorNSURLSessionImpl()
        
        downloadSearchesInteractor.execute { (searches: Searches) in
            // Todo OK
            Global.searches = searches
            
            self.searchesTableView.delegate = self
            self.searchesTableView.dataSource = self
            self.searchesTableView.reloadData()
            
        }
    }
    
    func deleteFavoriteSearch(params: Dictionary<String, Any>?, name: String?, action: String, favoriteSearchId: String?) {
        let favoriteSearchInteractor: FavoriteSearchInteractor = FavoriteSearchInteractorNSURLSessionImpl()
        
        favoriteSearchInteractor.execute(params: params, name: name, action: action, favoriteSearchId: favoriteSearchId) { (responseApi: ResponseApi?) in
            // Todo OK
            if responseApi == nil {
                self.searchesDownload()
            } else {
                if let message = responseApi?.message {
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let message = responseApi?.error?.message else { return }
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
