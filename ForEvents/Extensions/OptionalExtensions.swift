//
//  OptionalExtensions.swift
//  ForEvents
//
//  Created by luis gomez alonso on 24/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
