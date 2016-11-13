//
//  User.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

class User {
    
    // Singleton - call via User.shared
    static var shared = User()
    
    var hasDriveNowAccount: Bool {
        // TODO: Add logic by querying, if username and password is stored -> change return value
        return true
    }
    
    var hasCar2GoAccount: Bool {
        // TODO: Add logic by querying, if username and password is stored -> change return value
        return true
    }
    
    private init() {
        
    }

}
