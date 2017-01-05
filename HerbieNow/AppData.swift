//
//  AppData.swift
//  HerbieNow
//
//  Created by Benno Kress on 20.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import KeychainAccess

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

    /// Get username for the specified provider from Keychain
    func getUsername(for provider: Provider) -> String?

    /// Get password for the specified provider from Keychain
    func getPassword(for provider: Provider) -> String?

    /// Get X-Auth-Token for the specified provider from Keychain
    func getXAuthToken(for provider: Provider) -> String?

    /// Get Open-Car-Token for the specified provider from Keychain
    func getOpenCarToken(for provider: Provider) -> String?

    /// Delete all saved credentials for the specified provider from Keychain
    func deleteCredentials(for provider: Provider)
    
    func setNearestCar2GoCity(_ cityName:String)
    
    func getNearestCar2GoCity() -> String?
}

class AppData {

    let userDefaults = UserDefaults.standard
    let keychain = Keychain(service: "de.lmu.HerbieNow").synchronizable(true)
    var nearestCar2GoCity : String?
    
    var userLocation: Location?

    // Singleton - call via AppData
    static var shared = AppData()
    private init() {}

    /// Add a value to the Keychain.
    fileprivate func addToKeychain(value: String, forKey key: String) {
        keychain[key] = value
    }

    /// Find a value for the specified key in Keychain. Returns nil, if none found.
    fileprivate func findValueInKeychain(forKey key: String) -> String? {
        do {
            return try keychain.getString(key)
        } catch {
            return nil
        }
    }

    /// Remove the saved value for the specified key from Keychain.
    fileprivate func removeValueFromKeychain(forKey key: String) {
        do {
            try keychain.remove(key)
        } catch let error {
            print(Debug.error(class: self, func: #function, message: "Keychain remove value error: \(error)"))
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

    // MARK: - Get Data

    func getUsername(for provider: Provider) -> String? {
        return findValueInKeychain(forKey: "\(provider.rawValue) Username")
    }

    func getPassword(for provider: Provider) -> String? {
        return findValueInKeychain(forKey: "\(provider.rawValue) Password")
    }

    func getXAuthToken(for provider: Provider) -> String? {
        return findValueInKeychain(forKey: "\(provider.rawValue) X-Auth-Token")
    }

    func getOpenCarToken(for provider: Provider) -> String? {
        return findValueInKeychain(forKey: "\(provider.rawValue) Open-Car-Token")
    }

    // MARK: - Delete Data

    func deleteCredentials(for provider: Provider) {
        removeValueFromKeychain(forKey: "\(provider.rawValue) Username")
        removeValueFromKeychain(forKey: "\(provider.rawValue) Password")
        removeValueFromKeychain(forKey: "\(provider.rawValue) X-Auth-Token")
        removeValueFromKeychain(forKey: "\(provider.rawValue) Open-Car-Token")
    }

    // MARK: - User Location

    func updateUserLocation(to location: Location) {
        userLocation = location
        print(Debug.info(class: self, func: #function, message: "New Location: \(userLocation?.coordinateDescription ?? "Location should be updated, but was not valid!")"))
    }

    func getUserLocation() -> Location? {
        return userLocation
    }
    
    func setNearestCar2GoCity(_ cityName:String){
        self.nearestCar2GoCity = cityName
    }
    
    func getNearestCar2GoCity() -> String? {
        return self.nearestCar2GoCity
    }

}
