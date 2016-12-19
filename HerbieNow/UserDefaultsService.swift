//
//  UserDefaultsService.swift
//  HerbieNow
//
//  Created by Benno Kress on 17.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

class UserDefaultsService {

    let userDefaults = UserDefaults.standard

    // Singleton - call via UserDefaultsService.shared
    static var shared = UserDefaultsService()
    private init() {}

    /// Add a value to the UserDefaults.
    func add(value: String, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }

    /// Find a value for the specified key in UserDefaults. Returns nil, if none found.
    func findValue(forKey key: String) -> String? {
        if let value = userDefaults.string(forKey: key) {
            return value
        } else {
            return nil
        }
    }
    
    /// Remove the saved value for the specified key from UserDefaults.
    func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

}
