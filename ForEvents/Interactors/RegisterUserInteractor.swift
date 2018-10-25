//
//  RegisterUserInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 25/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol RegisterUserInteractor {
    func execute(user: User, onSuccess: @escaping () -> Void, onError: errorClosure)
    func execute(user: User, onSuccess: @escaping () -> Void)
}
