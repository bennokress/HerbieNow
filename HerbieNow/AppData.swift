//
//  AppData.swift
//  HerbieNow
//
//  Created by Benno Kress on 20.12.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import Locksmith

protocol AppDataProtocol {

    // MARK: Location
    
    var userLocation: Location? { get set }

    /// Update the user location
    func updateUserLocation(to location: Location)

    /// Update nearest Car2Go City
    func updateNearestCar2GoCity(to cityString: String)

    /// Get the user location
    func getUserLocation() -> Location?
    
    // MARK: Keychain

    /// Add username for the specified provider to Keychain
    func addUsername(_ username: String, for provider: Provider)

    /// Add password for the specified provider to Keychain
    func addPassword(_ password: String, for provider: Provider)

    /// Add User ID for the specified provider to Keychain
    func addUserID(_ id: String, for provider: Provider)

    /// Add X-Auth-Token for the specified provider to Keychain
    func addXAuthToken(_ xAuthToken: String, for provider: Provider)

    /// Add Open-Car-Token for the specified provider to Keychain
    func addOpenCarToken(_ openCarToken: String, for provider: Provider)

    /// Add OAuth Token for the specified provider to Keychain
    func addOAuthToken(_ credentialKey: String, for provider: Provider)

    /// Add OAuth Token Secret for the specified provider to Keychain
    func addOAuthTokenSecret(_ credentialKey: String, for provider: Provider)
    
    /// Add filterset configuration to Keychain
    func addNewFilterset(_ filterset: Filterset)

    /// Get username for the specified provider from Keychain
    func getUsername(for provider: Provider) -> String?

    /// Get password for the specified provider from Keychain
    func getPassword(for provider: Provider) -> String?

    /// Get User ID for the specified provider from Keychain
    func getUserID(for provider: Provider) -> String?

    /// Get X-Auth-Token for the specified provider from Keychain
    func getXAuthToken(for provider: Provider) -> String?

    /// Get Open-Car-Token for the specified provider from Keychain
    func getOpenCarToken(for provider: Provider) -> String?

    /// Get OAuth Token for the specified provider from Keychain
    func getOAuthToken(for provider: Provider) -> String?

    /// Get OAuth Token Secret for the specified provider from Keychain
    func getOAuthTokenSecret(for provider: Provider) -> String?
    
    /// Get filterset configuration from Keychain
    func getFiltersets() -> [Filterset?]

    /// Delete all saved credentials for the specified provider from Keychain
    func deleteCredentials(for provider: Provider)
    
    /// Deletes a filterset at the provided index
    func deleteFilterset(at index: Int)
}

// MARK: -
class AppData {
    
    // MARK: Links

    let userDefaults = UserDefaults.standard
    
    // MARK: Data & Settings
    
    let appIdentifier = "de.lmu.HerbieNow"
    var userLocation: Location?
    var nearestCar2GoCity: String = "München"
    
    // MARK: Private Initalization & Public Singleton
    
    static var shared = AppData()
    private init() {}

}

// MARK: - App Data Protocol Conformance
extension AppData: AppDataProtocol {

    // MARK: Add Data

    func addUsername(_ username: String, for provider: Provider) {
        addToKeychain(value: username, forKey: "\(provider.rawValue) Username")
    }

    func addPassword(_ password: String, for provider: Provider) {
        addToKeychain(value: password, forKey: "\(provider.rawValue) Password")
    }

    func addUserID(_ id: String, for provider: Provider) {
        addToKeychain(value: id, forKey: "\(provider.rawValue) User ID")
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
    
    func addNewFilterset(_ filterset: Filterset) {
        var savedFiltersets = getFiltersets()
        savedFiltersets.replaceElement(at: filterset.position-1, with: filterset)
        var filtersetString = ""
        for filterset in savedFiltersets {
            if let savedFilterset = filterset {
                filtersetString.append(savedFilterset.asString)
                filtersetString.append("*")
            } else {
                filtersetString.append(" *")
            }
        }
        filtersetString.removeLastCharacter() // this is an unused *
        addToKeychain(value: filtersetString, forKey: "Filterset Configurations")
    }
    
    func updateUserLocation(to location: Location) {
        userLocation = location
    }
    
    func updateNearestCar2GoCity(to cityString: String) {
        nearestCar2GoCity = cityString
    }

    // MARK: Get Data

    func getUsername(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) Username")
    }

    func getPassword(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) Password")
    }

    func getUserID(for provider: Provider) -> String? {
        return findStringInKeychain(forKey: "\(provider.rawValue) User ID")
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
    
    func getFiltersets() -> [Filterset?] {
        let savedFiltersetsString = findStringInKeychain(forKey: "Filterset Configurations")
        if let filtersetStringArray = savedFiltersetsString?.splitted(by: "*") {
            var filtersetConfiguration: [Filterset?] = []
            for filtersetString in filtersetStringArray {
                if filtersetString.contains(":") {
                    filtersetConfiguration.append(Filterset(from: filtersetString))
                } else {
                    filtersetConfiguration.append(nil)
                }
            }
            return filtersetConfiguration
        } else {
            return [nil, nil, nil, nil, nil, nil, nil, nil, nil]
        }
    }
    
    func getUserLocation() -> Location? {
        return userLocation
    }

    // MARK: Delete Data

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
            removeValueFromKeychain(forKey: "\(provider.rawValue) User ID")
        }
    }
    
    func deleteFilterset(at index: Int) {
        var savedFiltersets = getFiltersets()
        savedFiltersets.replaceElement(at: index-1, with: nil)
        var filtersetString = ""
        for filterset in savedFiltersets {
            if let savedFilterset = filterset {
                filtersetString.append(savedFilterset.asString)
                filtersetString.append("*")
            } else {
                filtersetString.append(" *")
            }
        }
        filtersetString.removeLastCharacter() // this is an unused *
        addToKeychain(value: filtersetString, forKey: "Filterset Configurations")
    }

}

// MARK: - Internal Functions
extension AppData: InternalRouting {
    
    fileprivate func addToKeychain(value: String, forKey key: String) {
        do {
            try Locksmith.updateData(data: [key : value], forUserAccount: "\(appIdentifier) \(key)")
        } catch {
            Debug.print(.error(source: .location(Source()), message: "Saving \(key) to keychain was unsuccessful."))
        }
    }
    
    fileprivate func addToKeychain(value: Data, forKey key: String) {
        do {
            try Locksmith.updateData(data: [key : value], forUserAccount: "\(appIdentifier) \(key)")
        } catch {
            Debug.print(.error(source: .location(Source()), message: "Saving \(key) to keychain was unsuccessful."))
        }
    }
    
    fileprivate func findStringInKeychain(forKey key: String) -> String? {
        let data = Locksmith.loadDataForUserAccount(userAccount: "\(appIdentifier) \(key)")
        return data?[key] as? String
    }
    
    fileprivate func findDataInKeychain(forKey key: String) -> Data? {
        let data = Locksmith.loadDataForUserAccount(userAccount: "\(appIdentifier) \(key)")
        return data?[key] as? Data
    }
    
    fileprivate func removeValueFromKeychain(forKey key: String) {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "\(appIdentifier) \(key)")
        } catch {
            Debug.print(.error(source: .location(Source()), message: "Deleting \(key) from keychain was unsuccessful."))
        }
    }
    
    fileprivate func addToUserDefaults(value: String, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }
    
    fileprivate func findValueInUserDefaults(forKey key: String) -> String? {
        if let value = userDefaults.string(forKey: key) {
            return value
        } else {
            return nil
        }
    }
    
    fileprivate func removeValueFromUserDefaults(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
}
