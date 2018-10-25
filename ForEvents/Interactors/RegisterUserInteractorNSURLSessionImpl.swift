//
//  RegisterUserInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 25/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class RegisterUserInteractorNSURLSessionImpl: RegisterUserInteractor {
    func execute(user: User, onSuccess: @escaping () -> Void, onError: errorClosure) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlRegPath
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = Constants.urlPostMethod
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers[Constants.urlHeadersConst] = Constants.urlJsonContentType
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
        } catch {
            print(error)
        }
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            
            OperationQueue.main.addOperation {
                assert(Thread.current == Thread.main)
                
                if responseError == nil {
                    // APIs usually respond with the data you just sent in your POST request
                    if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                        print("response: ", utf8Representation)
                    }
                } else {
                    if let myError = onError {
                        myError(responseError!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func execute(user: User, onSuccess: @escaping () -> Void) {
        execute(user: user, onSuccess: onSuccess, onError: nil)
    }
    
    
}
