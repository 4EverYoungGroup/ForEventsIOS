//
//  DownloadAssistsInteractorFakeImpl.swift
//  ForEvents
//
//  Created by luis gomez alonso on 14/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

class DownloadAssistsInteractorFakeImpl: DownloadEventsInteractor {
    func execute(onSuccess: @escaping (Events) -> Void) {
        execute(onSuccess: onSuccess, onError: nil)
    }
    
    func execute(onSuccess: @escaping (Events) -> Void, onError: errorClosure = nil) {
        let events = Events()
        
        for i in 0...3 {
            let event = Event(name: "Evento número \( i )")
            switch i {
            case 0:
                event.name = "Marathon urbano"
                event.images = ["https://cdn.pixabay.com/photo/2014/01/24/13/32/marathon-250987_960_720.jpg"]
                event.latitude = 40.155421
                event.longitude = -5.241031
            case 1:
                event.name = "Comida en el campo"
                event.images = ["https://cdn.pixabay.com/photo/2015/07/10/17/53/cheers-839865_960_720.jpg"]
                event.latitude = 40.156503
                event.longitude = -5.244384
            case 2:
                event.name = "Concierto de piano"
                event.images = ["https://cdn.pixabay.com/photo/2015/02/04/00/15/piano-623182_960_720.jpg"]
                event.latitude = 40.153827
                event.longitude = -5.245555
            case 3:
                event.name = "Concurso de globos de aire"
                event.images = ["https://cdn.pixabay.com/photo/2014/09/08/17/08/hot-air-balloons-439331_960_720.jpg","https://cdn.pixabay.com/photo/2018/10/21/17/35/hot-air-balloons-3763287_960_720.jpg"]
                event.latitude = 40.153546
                event.longitude = -5.244996
            default:
                event.images = ["https://cdn.pixabay.com/photo/2015/07/10/17/53/cheers-839865_960_720.jpg"]
            }
            
            
            events.add(event: event)
        }
        
        OperationQueue.main.addOperation {
            activityIndicator.removeFromSuperview()
            onSuccess(events)
        }
    }
    
}
