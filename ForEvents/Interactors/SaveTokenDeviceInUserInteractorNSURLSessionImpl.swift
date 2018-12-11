//
//  SaveTokenDeviceInUserInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 11/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class SaveTokenDeviceInUserInteractorNSURLSessionImpl: SaveTokenDeviceInUserInteractor {
    func execute(onSuccess: @escaping (ResponseApi?) -> Void, onError: errorClosure) {
        let userID: String = UserDefaults.standard.value(forKey: Constants.userID) as! String
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlGetUserPath+userID
        if let username = UserDefaults.standard.value(forKey: Constants.useremail) {
            if let tokenValue = checkToken(username: username as! String) {
                urlComponents.queryItems = [URLQueryItem(name: "token", value: tokenValue)]
            }
        }
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = Constants.urlPutMethod
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers[Constants.urlHeadersConst] = Constants.urlJsonContentType
        request.allHTTPHeaderFields = headers
        
        //Recover tokenDevice
        let tokenDevice: String = UserDefaults.standard.value(forKey: Constants.tokenDevice) as! String
        let tokenFB = TokenFB(tokenFB: tokenDevice)
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(tokenFB)
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
                        onSuccess(nil)
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
    
    func execute(onSuccess: @escaping (ResponseApi?) -> Void) {
        execute(onSuccess: onSuccess, onError: nil)
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
