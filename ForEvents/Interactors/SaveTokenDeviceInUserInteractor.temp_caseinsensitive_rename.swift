//
//  saveTokenDeviceInUserInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 11/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol RegisterUserInteractor {
    func execute(user: User, onSuccess: @escaping (ResponseApi?) -> Void, onError: errorClosure)
    func execute(user: User, onSuccess: @escaping (ResponseApi?) -> Void)
}
