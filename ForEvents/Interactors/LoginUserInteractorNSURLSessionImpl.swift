//
//  LoginUserInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class LoginUserInteractorNSURLSessionImpl: LoginUserInteractor {
    
    func execute(user: UserLogin, onSuccess: @escaping (UserLogin?, ResponseApi?) -> Void, onError: errorClosure) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlLoginPath
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
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            OperationQueue.main.addOperation {
                assert(Thread.current == Thread.main)
                
                if error == nil {
                    activityIndicator.removeFromSuperview()
                    if (self.checkStatusCode(response: response)) {
                        //prepare token
                        do {
                            let decoder = JSONDecoder()
                            let userLogin = try decoder.decode(UserLogin.self, from:
                                data!)
                            onSuccess(userLogin, nil)
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    } else {
                        // TODO reponse login service must be ok and message only
                        //prepare responseApi
                        do {
                            let decoder = JSONDecoder()
                            let responseApi = try decoder.decode(ResponseApi.self, from:
                                data!)
                            onSuccess(nil, responseApi)
                        } catch let parsingError {
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
    
    func execute(user: UserLogin, onSuccess: @escaping (UserLogin?, ResponseApi?) -> Void) {
        execute(user: user, onSuccess: onSuccess, onError: nil)
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
