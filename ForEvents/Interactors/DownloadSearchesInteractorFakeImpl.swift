//
//  DownloadSearchesInteractorFakeImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class DownloadSearchesInteractorFakeImpl: DownloadSearchesInteractor {
    
    func execute(onSuccess: @escaping (Searches) -> Void) {
        execute(onSuccess: onSuccess, onError: nil)
    }
    
    func execute(onSuccess: @escaping (Searches) -> Void, onError: errorClosure = nil) {
        let searchs = Searches()
        
        for i in 0...8 {
            let search = Search(query: "Búsqueda número \( i )", createDate: Date())
            searchs.add(search: search)
        }
        
        OperationQueue.main.addOperation {
            activityIndicator.removeFromSuperview()
            onSuccess(searchs)
        }
    }
}

