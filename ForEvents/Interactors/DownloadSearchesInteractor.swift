//
//  DownloadSearchesInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 19/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol DownloadSearchesInteractor {
    func execute(onSuccess: @escaping (Searches) -> Void, onError: errorClosure)
    func execute(onSuccess: @escaping (Searches) -> Void)
}
