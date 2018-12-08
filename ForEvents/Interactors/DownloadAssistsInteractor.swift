//
//  DownloadAssistsInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 08/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol DownloadAssistsInteractor {
    func execute(onSuccess: @escaping (Events) -> Void, onError: errorClosure)
    func execute(onSuccess: @escaping (Events) -> Void)
}
