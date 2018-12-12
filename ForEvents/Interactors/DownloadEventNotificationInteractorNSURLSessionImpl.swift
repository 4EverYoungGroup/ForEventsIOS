//
//  DownloadEventNotificationInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 12/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class DownloadEventNotificationInteractorNSURLSessionImpl: DownloadEventNotificationInteractor {
    func execute(eventId: String, onSuccess: @escaping (Events) -> Void, onError: errorClosure) {
        let userID: String = UserDefaults.standard.value(forKey: Constants.userID) as! String
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlEventsPath
        if let username = UserDefaults.standard.value(forKey: Constants.useremail) {
            if let tokenValue = checkToken(username: username as! String) {
                urlComponents.queryItems = [
                    URLQueryItem(name: "id", value: eventId),
                    URLQueryItem(name: "userId", value: userID),
                    URLQueryItem(name: "media", value: "url"),
                    URLQueryItem(name: "event_type", value: "name"),
                    URLQueryItem(name: "token", value: tokenValue)]
            }
        }
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
                    activityIndicator.removeFromSuperview()
                    if (self.checkStatusCode(response: response)) {
                        //OK
                        let events = parseEvents(data: data!)
                        //return Events
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
    
    func execute(eventId: String, onSuccess: @escaping (Events) -> Void) {
        execute(eventId: eventId, onSuccess: onSuccess, onError: nil)
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
