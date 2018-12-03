//
//  TransactionInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 03/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol TransactionInteractor {
    func execute(action: String, eventId: String?, transactionId: String?, onSuccess: @escaping (ResponseApi?) -> Void, onError: errorClosure)
    func execute(action: String, eventId: String?, transactionId: String?, onSuccess: @escaping (ResponseApi?) -> Void)
}
