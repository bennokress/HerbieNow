//
//  KeychainService.swift
//  HerbieNow
//
//  Created by Benno Kress on 17.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainService {

    let keychain = Keychain(service: "de.lmu.HerbieNow").synchronizable(true)

    // Singleton - call via KeychainService.shared
    static var shared = KeychainService()
    private init() {}

    /// Add a value to the Keychain.
    func add(value: String, forKey key: String) {
        keychain[key] = value
    }

    /// Find a value for the specified key in Keychain. Returns nil, if none found.
    func findValue(forKey key: String) -> String? {
        do {
            return try keychain.getString(key)
        } catch {
            return nil
        }
    }

}
