//
//  FavoriteSearchInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 06/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class FavoriteSearchInteractorNSURLSessionImpl: FavoriteSearchInteractor {
    
    func execute(params: Dictionary<String, Any>?, name: String?, action: String, favoriteSearchId: String?,
                 onSuccess: @escaping (ResponseApi?) -> Void, onError: errorClosure) {
        var position: [Float] = []
        var queryTextString: String? = nil
        var eventTypeString: String? = nil
        var distance: Int = 0
        let userId = UserDefaults.standard.value(forKey: Constants.userID)
        //let name = name!
        
        if action == Constants.favoriteSearchAdd {
            //recover find parameters
            position = params!["position"] as! [Float]
            if let queryText: String = params!["queryText"] as? String {
                queryTextString = queryText
            }
            if let eventTypes: [EventTypeCheck] = params!["eventTypes"] as? [EventTypeCheck] {
                let eventTypeID = eventTypes.map({String($0.id)})
                eventTypeString = eventTypeID.joined(separator: ",")
            }
            distance = params!["distance"] as! Int
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        if action == Constants.favoriteSearchAdd {
            urlComponents.path = Constants.urlFavoriteSearchPath
            urlComponents.queryItems = [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "event_type", value: eventTypeString),
                URLQueryItem(name: "queryText", value: queryTextString),
                URLQueryItem(name: "location", value: String(position[0])+","+String(position[1])+","+String(distance)),
                URLQueryItem(name: "userId", value: (userId as! String))]
        } else {
            urlComponents.path = Constants.urlFavoriteSearchPath+"/"+favoriteSearchId!
            urlComponents.queryItems = [
                URLQueryItem(name: "userId", value: (userId as! String))]
        }
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        if action == Constants.favoriteSearchAdd {
            request.httpMethod = Constants.urlPostMethod
        } else {
            request.httpMethod = Constants.urlDelMethod
        }
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers[Constants.urlHeadersConst] = Constants.urlJsonContentType
        request.allHTTPHeaderFields = headers
        
        //TODO Include Token
        let token = ""
        request.httpBody = Data(base64Encoded: token)
        
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            OperationQueue.main.addOperation {
                assert(Thread.current == Thread.main)
                
                if error == nil {
                    activityIndicator.removeFromSuperview()
                    if (self.checkStatusCode(response: response)) {
                        if action == Constants.transactionAdd {
                            //prepare TransactionApi
                            do {
                                let decoder = JSONDecoder()
                                let response = try decoder.decode(FavoriteSearchApiResponse.self, from:
                                    data!)
                                Global.favoriteSearchIdLast = response.data.favoriteSerchId
                                onSuccess(nil)
                            } catch let parsingError {
                                //TODO alert with error
                                print("Error", parsingError)
                            }
                        } else {
                            onSuccess(nil)
                        }
                    } else {
                        //prepare responseApi
                        do {
                            let decoder = JSONDecoder()
                            let responseApi = try decoder.decode(ResponseApi.self, from:
                                data!)
                            onSuccess(responseApi)
                        } catch let parsingError {
                            //TODO alert with error
                            print("Error", parsingError)
                        }
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
    
    func execute(params: Dictionary<String, Any>?, name: String?, action: String, favoriteSearchId: String?,
                 onSuccess: @escaping (ResponseApi?) -> Void) {
        execute(params: params, name: name, action: action, favoriteSearchId: favoriteSearchId, onSuccess: onSuccess, onError: nil)
    }
    
    func checkStatusCode(response:URLResponse?) -> Bool {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return false
        }
        if statusCode != 200 && statusCode != 201 && statusCode != 204 {
            return false
        }
        return true
    }
}
