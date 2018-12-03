//
//  GetCitiesInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 28/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class GetCitiesInteractorNSURLSessionImpl: GetCitiesInteractor {
    func execute(queryText: String, onSuccess: @escaping ([City]?) -> Void, onError: errorClosure) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlCitiesPath
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "200"),
            URLQueryItem(name: "queryText", value: queryText)]
        
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
                        do {
                            let decoder = JSONDecoder()
                            let cityAPI = try decoder.decode(CityAPI.self, from: data!)
                            let cities = cityAPI.result
                            //return User
                            onSuccess(cities)
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
    
    func execute(queryText: String, onSuccess: @escaping ([City]?) -> Void) {
        execute(queryText: queryText, onSuccess: onSuccess, onError: nil)
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
