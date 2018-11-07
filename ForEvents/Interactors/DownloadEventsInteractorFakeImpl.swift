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
            switch i {
            case 0:
                event.name = "Fiesta del confeti"
                event.images = ["https://cdn.pixabay.com/photo/2017/07/21/23/57/concert-2527495_960_720.jpg","https://cdn.pixabay.com/photo/2017/08/02/13/09/confetti-2571539_960_720.jpg"]
            case 1:
                event.name = "Cine al aire libre"
                event.images = ["https://cdn.pixabay.com/photo/2017/11/24/10/43/admission-2974645_960_720.jpg"]
            case 2:
                event.name = "Comida en el campo"
                event.images = ["https://cdn.pixabay.com/photo/2015/07/10/17/53/cheers-839865_960_720.jpg"]
            case 3:
                event.name = "Concurso de globos de aire"
                event.images = ["https://cdn.pixabay.com/photo/2014/09/08/17/08/hot-air-balloons-439331_960_720.jpg","https://cdn.pixabay.com/photo/2018/10/21/17/35/hot-air-balloons-3763287_960_720.jpg"]
            case 4:
                event.name = "Marathon urbano"
                event.images = ["https://cdn.pixabay.com/photo/2014/01/24/13/32/marathon-250987_960_720.jpg"]
            case 5:
                event.name = "Concierto de piano"
                event.images = ["https://cdn.pixabay.com/photo/2015/02/04/00/15/piano-623182_960_720.jpg"]
            case 6:
                event.name = "Día medieval"
                event.images = ["https://cdn.pixabay.com/photo/2017/07/29/15/44/reiter-2551863_960_720.jpg"]
            case 7:
                event.name = "Teatro"
                event.images = ["https://cdn.pixabay.com/photo/2014/08/31/10/03/theater-432045_960_720.jpg"]
            case 8:
                event.name = "Fuegos artificiales"
                event.images = ["https://cdn.pixabay.com/photo/2015/07/15/11/49/fireworks-846063_960_720.jpg","https://cdn.pixabay.com/photo/2016/10/03/20/00/fireworks-1712688_960_720.jpg"]
            default:
                event.images = ["https://cdn.pixabay.com/photo/2015/07/10/17/53/cheers-839865_960_720.jpg"]
            }
            
            
            events.add(event: event)
        }
        
        OperationQueue.main.addOperation {
            onSuccess(events)
        }
    }
    
}
