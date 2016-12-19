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
    private func add(value: String, forKey key: String) {
        keychain[key] = value
    }

    /// Find a value for the specified key in Keychain. Returns nil, if none found.
    private func findValue(forKey key: String) -> String? {
        do {
            return try keychain.getString(key)
        } catch {
            return nil
        }
    }

    /// Remove the saved value for the specified key from Keychain.
    private func removeValue(forKey key: String) {
        do {
            try keychain.remove(key)
        } catch let error {
            print("Keychain remove value error: \(error)")
        }
    }

    /// Add password for the specified provider to UserDefaults
    func addPassword(_ password: String, for provider: Provider) {
        add(value: password, forKey: "\(provider.rawValue) Password")
    }

    /// Add X-Auth-Token for the specified provider to UserDefaults
    func addXAuthToken(_ xAuthToken: String, for provider: Provider) {
        add(value: xAuthToken, forKey: "\(provider.rawValue) X-Auth-Token")
    }

    /// Add Open-Car-Token for the specified provider to UserDefaults
    func addOpenCarToken(_ openCarToken: String, for provider: Provider) {
        add(value: openCarToken, forKey: "\(provider.rawValue) Open-Car-Token")
    }

    /// Get password for the specified provider from UserDefaults
    func getPassword(for provider: Provider) -> String? {
        return findValue(forKey: "\(provider.rawValue) Password")
    }

    /// Get X-Auth-Token for the specified provider from UserDefaults
    func getXAuthToken(for provider: Provider) -> String? {
        return findValue(forKey: "\(provider.rawValue) X-Auth-Token")
    }

    /// Get Open-Car-Token for the specified provider from UserDefaults
    func getOpenCarToken(for provider: Provider) -> String? {
        return findValue(forKey: "\(provider.rawValue) Open-Car-Token")
    }

    /// Delete password for the specified provider from UserDefaults
    func deletePassword(for provider: Provider) {
        removeValue(forKey: "\(provider.rawValue) Password")
    }

    /// Delete X-Auth-Token for the specified provider from UserDefaults
    func deleteXAuthToken(for provider: Provider) {
        removeValue(forKey: "\(provider.rawValue) X-Auth-Token")
    }

    /// Delete Open-Car-Token for the specified provider from UserDefaults
    func deleteOpenCarToken(for provider: Provider) {
        removeValue(forKey: "\(provider.rawValue) Open-Car-Token")
    }

}
