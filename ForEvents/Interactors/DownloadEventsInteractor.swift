//
//  DownloadEventsInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 01/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol DownloadEventsInteractor {
    func execute(params: Dictionary<String, Any>,
                 onSuccess: @escaping (Events) -> Void, onError: errorClosure)
    func execute(params: Dictionary<String, Any>,
                 onSuccess: @escaping (Events) -> Void)
}
