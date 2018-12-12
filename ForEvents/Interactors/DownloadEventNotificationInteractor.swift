//
//  DownloadEventNotificationInteractor.swift
//  ForEvents
//
//  Created by luis gomez alonso on 12/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

protocol DownloadEventNotificationInteractor {
    func execute(eventId: String, onSuccess: @escaping (Events) -> Void, onError: errorClosure)
    func execute(eventId: String, onSuccess: @escaping (Events) -> Void)
}
