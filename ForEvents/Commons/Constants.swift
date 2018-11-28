//
//  Constants.swift
//  ForEvents
//
//  Created by luis gomez alonso on 24/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

struct Constants {
    //userDefaults
    static let hasLoginKey = "hasLoginKey"
    static let username = "username"
    static let userID = "userID"
    //email validation reg-expression
    static let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let regTitle = "Registro ForEvents"
    static let loginTitle = "Login ForEvents"
    //url parameters
    static let urlScheme = "https"
    static let urlHost = "services.4events.net"
    static let urlLoginPath = "/apiv1/users/login"
    static let urlRegPath = "/apiv1/users/register"
    static let urlRecoverPath = "/apiv1/users/recover"
    static let urlEventsPath = "/apiv1/events"
    static let urlGetUserPath = "/apiv1/users/"
    static let urlUpdateUserPath = "/apiv1/users/"
    static let urlEventTypePath = "/apiv1/EventTypes/"
    static let urlPostMethod = "POST"
    static let urlGetMethod = "GET"
    static let urlPutMethod = "PUT"
    static let urlDelMethod = "DELETE"
    static let urlHeadersConst = "Content-Type"
    static let urlJsonContentType = "application/json"
    //location
    static let latitudeDefault = 41.512860
    static let longitudeDefault = -5.747090
}

struct Global {
    static var events: Events? = nil
    static var eventTypesCheck: [EventTypeCheck]? = []
}
