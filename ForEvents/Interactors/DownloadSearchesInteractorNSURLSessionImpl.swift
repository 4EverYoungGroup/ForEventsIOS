//
//  DownloadSearchesInteractorFakeImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class DownloadSearchesInteractorNSURLSessionImpl: DownloadSearchesInteractor {
    
    func execute(onSuccess: @escaping (Searches) -> Void) {
        execute(onSuccess: onSuccess, onError: nil)
    }
    
    func execute(onSuccess: @escaping (Searches) -> Void, onError: errorClosure = nil) {
        let userId = UserDefaults.standard.value(forKey: Constants.userID)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlFavoriteSearchPath
        urlComponents.queryItems = [
            URLQueryItem(name: "userId", value: (userId as! String)),
            URLQueryItem(name: "includeTotal", value: "true"),
            URLQueryItem(name: "sort", value: "-create_date")]
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = Constants.urlGetMethod
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers[Constants.urlHeadersConst] = Constants.urlJsonContentType
        request.allHTTPHeaderFields = headers
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            OperationQueue.main.addOperation {
                assert(Thread.current == Thread.main)
                
                if error == nil {
                    //OK
                    activityIndicator.removeFromSuperview()
                    if (self.checkStatusCode(response: response)) {
                        let searches = parseSearches(data: data!)
                        //return Movements
                        onSuccess(searches)
                    } else {
                        let searches = Searches()
                        onSuccess(searches)
                    }
                } else {
                    if let myError = onError {
                        myError(error!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func checkStatusCode(response:URLResponse?) -> Bool {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return false
        }
        if statusCode != 200 && statusCode != 201 {
            return false
        }
        return true
    }
}

