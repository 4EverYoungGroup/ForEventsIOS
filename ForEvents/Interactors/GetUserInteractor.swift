//
//  GetUserInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol GetUserInteractor {
    func execute(userID: String, onSuccess: @escaping (User?) -> Void, onError: errorClosure)
    func execute(userID: String, onSuccess: @escaping (User?) -> Void)
}

