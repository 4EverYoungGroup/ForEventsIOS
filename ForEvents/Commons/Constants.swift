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
    static let hasCity = "hasCity"
    static let useremail = "useremail"
    static let userID = "userID"
    static let userFirstName = "userFirstName"
    static let userLastName = "userLastName"
    static let radio = "radio"
    static let locationAuth = "locationAuth"
    static let latitudeFavorite = "latitudeFavorite"
    static let longitudeFavorite = "longitudeFavorite"
    static let cityNameFavorite = "cityNameFavorite"
    //email validation reg-expression
    static let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let regTitle = "Registro ForEvents"
    static let loginTitle = "Login ForEvents"
    static let findTitle = "Búsqueda ForEvents"
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
    static let urlCitiesPath = "/apiv1/cities"
    static let urlTransactionsPath = "/apiv1/transactions/"
    static let urlTransactionsListPath = "/apiv1/transactions/list"
    static let urlFavoriteSearchPath = "/apiv1/favoriteSearches"
    static let urlPostMethod = "POST"
    static let urlGetMethod = "GET"
    static let urlPutMethod = "PUT"
    static let urlDelMethod = "DELETE"
    static let urlHeadersConst = "Content-Type"
    static let urlJsonContentType = "application/json"
    //transactions
    static let transactionAdd = "insert"
    static let transactionDelete = "delete"
    //favoriteSearch
    static let favoriteSearchAdd = "insert"
    static let favoriteSearchDelete = "delete"
    //location
    static let latitudeDefault = 41.512860
    static let longitudeDefault = -5.747090
    //radio kms
    static let distances:[Int] = [
        5,
        10,
        25,
        50,
        100]
}

struct Global {
    static var events: Events? = nil
    static var eventTypesCheck: [EventTypeCheck]? = []
    static var eventTypesCheckSearch: [EventTypeCheck]? = []
    static var citiesSelected: [City]? = []
    static var citySelectedId: String?
    static var citySelectedPosition: [Float]? = []
    static var citySelectedName: String? = nil
    static var distanceInMetres = 5000
    static var transactionIdLast: String? = nil
    static var favoriteSearchIdLast: String? = nil
    static var findParamsDict = Dictionary<String, AnyObject>()
    static var searchParamsDict = Dictionary<String, AnyObject>()
    static var searches: Searches? = nil
}
