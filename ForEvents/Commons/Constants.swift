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
    static let urlPostMethod = "POST"
    static let urlGetMethod = "GET"
    static let urlHeadersConst = "Content-Type"
    static let urlJsonContentType = "application/json"
}
