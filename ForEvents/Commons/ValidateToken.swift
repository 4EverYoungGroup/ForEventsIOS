//
//  ValidateToken.swift
//  ForEvents
//
//  Created by luis gomez alonso on 24/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation
import UIKit

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "ForEvents"
    static let accessGroup: String? = nil
}

class ValidateToken: UIViewController {
    
    func checkToken(username: String) -> Any {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        do {
            let tokenItem = KeychainTokenItem(service: KeychainConfiguration.serviceName,
                                              account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainToken = try tokenItem.readToken()
            return keychainToken
        } catch {
            fatalError("Error reading token from keychain - \(error)")
        }
    }
}

