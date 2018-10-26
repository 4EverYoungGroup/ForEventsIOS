//
//  LoginUserInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol LoginUserInteractor {
    func execute(user: UserLogin, onSuccess: @escaping (UserLogin?, ResponseApi?) -> Void, onError: errorClosure)
    func execute(user: UserLogin, onSuccess: @escaping (UserLogin?, ResponseApi?) -> Void)
}
