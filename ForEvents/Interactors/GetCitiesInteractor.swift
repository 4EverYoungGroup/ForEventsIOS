//
//  GetCitiesInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 28/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol GetCitiesInteractor {
    func execute(queryText: String, onSuccess: @escaping ([City]?) -> Void, onError: errorClosure)
    func execute(queryText: String, onSuccess: @escaping ([City]?) -> Void)
}
