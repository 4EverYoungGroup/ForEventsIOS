//
//  RecoverUserInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 29/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol RecoverUserInteractor {
    func execute(user: UserLogin, onSuccess: @escaping (ResponseApi?) -> Void, onError: errorClosure)
    func execute(user: UserLogin, onSuccess: @escaping (ResponseApi?) -> Void)
}
