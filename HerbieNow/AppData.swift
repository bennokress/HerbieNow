//
//  AppData.swift
//  HerbieNow
//
//  Created by Benno Kress on 20.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import Locksmith

protocol AppDataProtocol {

    var userLocation: Location? { get set }

    /// Update the user location
    func updateUserLocation(to location: Location)

    /// Get the user location
    func getUserLocation() -> Location?

    /// Add username for the specified provider to Keychain
    func addUsername(_ username: String, for provider: Provider)

    /// Add password for the specified provider to Keychain
    func addPassword(_ password: String, for provider: Provider)

    /// Add X-Auth-Token for the specified provider to Keychain
    func addXAuthToken(_ xAuthToken: String, for provider: Provider)

    /// Add Open-Car-Token for the specified provider to Keychain
    func addOpenCarToken(_ openCarToken: String, for provider: Provider)

    /// Add OAuth Token for the specified provider to Keychain
    func addOAuthToken(_ credentialKey: String, for provider: Provider)

    /// Add OAuth Token Secret for the specified provider to Keychain
    func addOAuthTokenSecret(_ credentialKey: String, for provider: Provider)

    /// Get username for the specified provider from Keychain
    func getUsername(for provider: Provider) -> String?

    /// Get password for the specified provider from Keychain
    func getPassword(for provider: Provider) -> String?

    /// Get X-Auth-Token for the specified provider from Keychain
    func getXAuthToken(for provider: Provider) -> String?

    /// Get Open-Car-Token for the specified provider from Keychain
    func getOpenCarToken(for provider: Provider) -> String?

    /// Get OAuth Token for the specified provider from Keychain
    func getOAuthToken(for provider: Provider) -> String?

    /// Get OAuth Token Secret for the specified provider from Keychain
    func getOAuthTokenSecret(for provider: Provider) -> String?

    /// Delete all saved credentials for the specified provider from Keychain
    func deleteCredentials(for provider: Provider)
}

class AppData {

    let userDefaults = UserDefaults.standard
    let appIdentifier = "de.lmu.HerbieNow"

    var userLocation: Location?

    // Singleton - call via AppData
    static var shared = AppData()
    private init() {}

    /// Add a value (String) to the Keychain.
    fileprivate func addToKeychain(value: String, forKey key: String) {
        do {
            try Locksmith.updateData(data: [key : value], forUserAccount: "\(appIdentifier) \(key)")
        } catch {
            print(Debug.error(class: name(of: self), func: #function, message: "Saving \(key) to keychain was unsuccessful."))
        }
    }

    /// Add a value (Data) to the Keychain.
    fileprivate func addToKeychain(value: Data, forKey key: String) {
        do {
            try Locksmith.updateData(data: [key : value], forUserAccount: "\(appIdentifier) \(key)")
        } catch {
            print(Debug.error(class: name(of: self), func: #function, message: "Saving \(key) to keychain was unsuccessful."))
        }
    }

    /// Find a value for the specified key in Keychain. Returns nil, if none found.
    fileprivate func findStringInKeychain(forKey key: String) -> String? {
        let data = Locksmith.loadDataForUserAccount(userAccount: "\(appIdentifier) \(key)")
        return data?[key] as? String
    }

    /// Find a value for the specified key in Keychain. Returns nil, if none found.
    fileprivate func findDataInKeychain(forKey key: String) -> Data? {
        let data = Locksmith.loadDataForUserAccount(userAccount: "\(appIdentifier) \(key)")
        return data?[key] as? Data
    }

    /// Remove the saved value for the specified key from Keychain.
    fileprivate func removeValueFromKeychain(forKey key: String) {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "\(appIdentifier) \(key)")
        } catch {
            print(Debug.error(class: name(of: self), func: #function, message: "Deleting \(key) from keychain was unsuccessful."))
        }
    }

    /// Add a value to the UserDefaults.
    fileprivate func addToUserDefaults(value: String, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }

    /// Find a value for the specified key in UserDefaults. Returns nil, if none found.
    fileprivate func findValueInUserDefaults(forKey key: String) -> String? {
        if let value = userDefaults.string(forKey: key) {
            return value
        } else {
            return nil
        }
    }

    /// Remove the saved value for the specified key from UserDefaults.
    fileprivate func removeValueFromUserDefaults(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

}

extension AppData: AppDataProtocol {

    // MARK: - Add Data

    func addUsername(_ username: String, for provider: Provider) {
        addToKeychain(value: username, forKey: "\(provider.rawValue) Username")
    }

    func addPassword(_ password: String, for provider: Provider) {
        addToKeychain(value: password, forKey: "\(provider.rawValue) Password")
    }

    func addXAuthToken(_ xAuthToken: String, for provider: Provider) {
        addToKeychain(value: xAuthToken, forKey: "\(provider.rawValue) X-Auth-Token")
    }

    func addOpenCarToken(_ openCarToken: String, for provider: Provider) {
        addToKeychain(value: openCarToken, forKey: "\(provider.rawValue) Open-Car-Token")
    }

    func addOAuthToken(_ credentialKey: String, for provider: Provider) {
        addToKeychain(value: credentialKey, forKey: "\(provider.rawValue) OAuth Token")
    }

    func addOAuthTokenSecret(_ credentialKey: String, for provider: Provider) {
        addToKeychain(value: credentialKey, forKey: "\(provider.rawValue) OAuth Token Secret")
    }

    func addOAuthCredentials(_ credentials: Data, for provider: Provider) {
        addToKeychain(value: credentials, forKey: "\(provider.rawValue) OAuth Credentials")
    }

    // MARK: - Get Data

    func getUsername(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) Username")
    }

    func getPassword(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) Password")
    }

    func getXAuthToken(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) X-Auth-Token")
    }

    func getOpenCarToken(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) Open-Car-Token")
    }

    func getOAuthToken(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) OAuth Token")
    }

    func getOAuthTokenSecret(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) OAuth Token Secret")
    }

    func getOAuthCredentials(for provider: Provider) -> Data? {
        return findDataInKeychain(forKey: "\(provider.rawValue) OAuth Credentials")
    }

    // MARK: - Delete Data

    func deleteCredentials(for provider: Provider) {
        switch provider {
        case .driveNow:
            removeValueFromKeychain(forKey: "\(provider.rawValue) Username")
            removeValueFromKeychain(forKey: "\(provider.rawValue) Password")
            removeValueFromKeychain(forKey: "\(provider.rawValue) X-Auth-Token")
            removeValueFromKeychain(forKey: "\(provider.rawValue) Open-Car-Token")
        case .car2go:
            removeValueFromKeychain(forKey: "\(provider.rawValue) OAuth Token")
            removeValueFromKeychain(forKey: "\(provider.rawValue) OAuth Token Secret")
            removeValueFromKeychain(forKey: "\(provider.rawValue) OAuth Credentials")
        }
    }

    // MARK: - User Location

    func updateUserLocation(to location: Location) {
        userLocation = location
        //        print(Debug.info(class: self, func: #function, message: "New Location: \(userLocation?.coordinateDescription ?? "Location should be updated, but was not valid!")"))
    }

    func getUserLocation() -> Location? {
        return userLocation
    }

}
