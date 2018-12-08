//
//  UpdateUserInteractorNSURLSessionImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class UpdateUserInteractorNSURLSessionImpl: UpdateUserInteractor {
    func execute(user: User, onSuccess: @escaping (User?) -> Void, onError: errorClosure) {
        let userID: String = UserDefaults.standard.value(forKey: Constants.userID) as! String
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlUpdateUserPath+userID
        if let username = UserDefaults.standard.value(forKey: Constants.username) {
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
        
        //Validate if user fields are empty to pass nil
        var userNil = user
        if (userNil.password?.isEmpty)! {
            userNil.password = nil
        }
        if (userNil.lastname?.isEmpty)! {
            userNil.lastname = nil
        }
        if (userNil.alias?.isEmpty)! {
            userNil.alias = nil
        }
        if (userNil.province?.isEmpty)! {
            userNil.province = nil
        }
        if (userNil.zipCode?.isEmpty)! {
            userNil.zipCode = nil
        }
        if (userNil.country?.isEmpty)! {
            userNil.country = nil
        }
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(userNil)
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
                    //OK
                    activityIndicator.removeFromSuperview()
                    //if (self.checkStatusCode(response: response)) {
                        do {
                            let decoder = JSONDecoder()
                            let userUpdate = try decoder.decode(UserUpdate.self, from: data!)
                            let user = userUpdate.user
                            //return User
                            onSuccess(user)
                        } catch let parsingError {
                            //TODO alert with error
                            print("Error", parsingError)
                        }
                    //}
                } else {
                    if let myError = onError {
                        myError(error!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func execute(user: User, onSuccess: @escaping (User?) -> Void) {
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
