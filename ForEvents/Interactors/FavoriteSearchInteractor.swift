//
//  FavoriteSearchInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 06/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol FavoriteSearchInteractor {
    func execute(params: Dictionary<String, Any>?, name: String?, action: String, favoriteSearchId: String?, onSuccess: @escaping (ResponseApi?) -> Void, onError: errorClosure)
    func execute(params: Dictionary<String, Any>?, name: String?, action: String, favoriteSearchId: String?, onSuccess: @escaping (ResponseApi?) -> Void)
}
