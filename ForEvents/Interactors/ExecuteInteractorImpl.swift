//
//  ExecuteOnceInteractorImpl.swift
//  MadridShops
//
//  Created by luis gomez alonso on 12/9/18.
//  Copyright © 2018 luis gomez alonso. All rights reserved.
//

import Foundation

class ExecuteInteractorImpl: ExecuteInteractor {
    func execute(closure: () -> Void) {
        closure()
    }
}
