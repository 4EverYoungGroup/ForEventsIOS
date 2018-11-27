//
//  DeleteUserInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 27/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol DeleteUserInteractor {
    func execute(onSuccess: @escaping () -> Void, onError: errorClosure)
    func execute(onSuccess: @escaping () -> Void)
}
