//
//  UpdateUserInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol UpdateUserInteractor {
    func execute(user: User, onSuccess: @escaping (User?) -> Void, onError: errorClosure)
    func execute(user: User, onSuccess: @escaping (User?) -> Void)
}
