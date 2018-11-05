//
//  DownloadEventsInteractorFakeImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 01/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class DownloadEventsInteractorFakeImpl: DownloadEventsInteractor {
    func execute(onSuccess: @escaping (Events) -> Void) {
        execute(onSuccess: onSuccess, onError: nil)
    }
    
    func execute(onSuccess: @escaping (Events) -> Void, onError: errorClosure = nil) {
        let events = Events()
        
        for i in 0...8 {
            let event = Event(name: "Evento número \( i )")
            
            events.add(event: event)
        }
        
        OperationQueue.main.addOperation {
            onSuccess(events)
        }
    }
    
}
