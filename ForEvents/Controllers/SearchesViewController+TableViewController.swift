//
//  SearchesViewController+TableViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

extension SearchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searches = Global.searches {
            return searches.count()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = searchTableViewCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SearchTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let search: Search = ((Global.searches?.get(index: indexPath.row))!)
        cell.refresh(search: search, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let search: Search = ((Global.searches?.get(index: indexPath.row))!)
        Global.searchParamsDict = convertToDictionary(text: search.query)! as [String : AnyObject]
        let searchDetailViewController = SearchDetailViewController()
        searchDetailViewController.modalPresentationStyle = .overFullScreen
        present(searchDetailViewController, animated: true, completion: nil)
        
        searchDetailViewController.onDoneBlock = { result in
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let search: Search = ((Global.searches?.get(index: indexPath.row))!)
        //Delete favoriteSearch - Alert
        let deleteFavoriteSearchAlertController = UIAlertController (title: "Atención, ha solicitado borrar su búsqueda", message: "Esta acción borrará su búsqueda favorita.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Borrar", style: .destructive) { (_) -> Void in
            //Delete favoriteSearch
            ExecuteInteractorImpl().execute {
                //Pass favoriteSearchId
                self.deleteFavoriteSearch(params: Global.findParamsDict as Dictionary<String, Any>, name: nil, action: Constants.favoriteSearchDelete, favoriteSearchId: search.id)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        deleteFavoriteSearchAlertController .addAction(settingsAction)
        deleteFavoriteSearchAlertController .addAction(cancelAction)
        self.present(deleteFavoriteSearchAlertController, animated: true, completion: nil)
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
