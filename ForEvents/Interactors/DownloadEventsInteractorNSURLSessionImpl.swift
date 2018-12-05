//
//  DownloadEventsInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 24/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class DownloadEventsInteractorNSURLSessionImpl: DownloadEventsInteractor {
    func execute(params: Dictionary<String, Any>,
                 onSuccess: @escaping (Events) -> Void, onError: errorClosure) {
        //recover find parameters
        let position: [Float] = params["position"] as! [Float]
        var queryTextString: String? = nil
        if let queryText: String = params["queryText"] as? String {
            queryTextString = queryText
        }
        var eventTypeString: String? = nil
        if let eventTypes: [EventTypeCheck] = params["eventTypes"] as? [EventTypeCheck] {
            let eventTypeID = eventTypes.map({String($0.id)})
            eventTypeString = eventTypeID.joined(separator: ",")
        }
        let distance: Int = params["distance"] as! Int
        
        let userId = UserDefaults.standard.value(forKey: Constants.userID)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlEventsPath
        urlComponents.queryItems = [
            URLQueryItem(name: "sort", value: "begin_date"),
            URLQueryItem(name: "event_typeId", value: eventTypeString),
            URLQueryItem(name: "queryText", value: queryTextString),
            URLQueryItem(name: "location", value: String(position[0])+","+String(position[1])+","+String(distance)),
            URLQueryItem(name: "media", value: "url"),
            URLQueryItem(name: "event_type", value: "name"),
            URLQueryItem(name: "userId", value: (userId as! String))]
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = Constants.urlGetMethod
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
                    //OK
                    activityIndicator.removeFromSuperview()
                    if (self.checkStatusCode(response: response)) {
                        let events = parseEvents(data: data!)
                        //return Movements
                        onSuccess(events)
                    } else {
                        let events = Events()
                        onSuccess(events)
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
    
    func execute(params: Dictionary<String, Any>,
                 onSuccess: @escaping (Events) -> Void) {
        execute(params: params, onSuccess: onSuccess, onError: nil)
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
