//
//  Logic.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol LogicProtocol {

    typealias Callback = (APICallResult) -> Void
    
    // MARK: App Data
    func getConfiguredFiltersets() -> [Int : Filterset]
    func isAccountConfigured(for provider: Provider) -> Bool
    func getFilterset(for id: Int) -> Filterset?
    func saveUpdatedLocation(_ location: Location)
    func save(username: String, password: String)
    func getLastKnownUserLocation() -> Location?

    // MARK: API Methods
    func login(with provider: Provider, as username: String?, withPassword password: String?, completion: @escaping Callback)
    func getUserData(from provider: Provider, completion: @escaping Callback)
    func getReservationStatus(from provider: Provider, completion: @escaping Callback)
    func getAvailableVehicles(from provider: Provider, around location: Location?, completion: @escaping Callback)
    func reserveVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback)
    func cancelReservation(with provider: Provider, completion: @escaping Callback)
    func openVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback)
    func closeVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback)
    
    // MARK: Convenience Getter
    func getAllAvailableVehicles(around location: Location?, completion: @escaping Callback)

}

// MARK: -
class Logic {

    typealias Callback = (APICallResult) -> Void
    
    // MARK: Links
    
    let appData: AppDataProtocol = AppData.shared

}

// MARK: - Logic Protocol Conformance
extension Logic: LogicProtocol {
    
    // MARK: App Data

    func saveUpdatedLocation(_ location: Location) {
        appData.updateUserLocation(to: location)
    }

    func save(username: String, password: String) {
        appData.addUsername(username, for: .driveNow)
        appData.addPassword(password, for: .driveNow)
    }

    func getConfiguredFiltersets() -> [Int : Filterset] {
        // TODO: Filtersets abfragen und zurückgeben als Dictionary mit Set-Nummer 1-9 und Filterset.
        return [:]

    }

    func isAccountConfigured(for provider: Provider) -> Bool {
        // TODO: Implement
        return true
    }

    func getFilterset(for id: Int) -> Filterset? {
        // TODO: Filterset holen, falls konfiguriert, sonst nil zurückgeben.
        return nil
    }
    func getLastKnownUserLocation() -> Location? {
        return appData.getUserLocation()
    }

    func logout(of provider:Provider) {
        appData.deleteCredentials(for: provider)
    }

    // MARK: API

    func login(with provider: Provider, as username: String?, withPassword password: String?, completion: @escaping Callback) {

        switch provider {
        case .driveNow:
            guard let dnUsername = username, let dnPassword = password else {
                let error = APICallResult.error(code: 0, codeDetail: "no_credentials_provided", message: "No Credentials passed with login call for DriveNow!", parentFunction: #function)
                completion(error)
                return
            }

            save(username: dnUsername, password: dnPassword)

            let api = provider.api
            api.login() { response in
                completion(response)
            }
        case .car2go:
            let api = provider.api
            api.login() { response in
                completion(response)
            }
        }

    }

    func getUserData(from provider: Provider, completion: @escaping Callback) {

        provider.api.getUserData() { response in
            completion(response)
        }

    }

    func getReservationStatus(from provider: Provider, completion: @escaping Callback) {

        provider.api.getReservationStatus() { response in
            completion(response)
        }

    }

    func getAvailableVehicles(from provider: Provider, around location: Location?, completion: @escaping Callback) {
        
        guard let location = location else {
            Debug.print(.error(source: .location(Source()), message: "No Location provided"))
            return
        }

        provider.api.getAvailableVehicles(around: location) { response in
            completion(response)
        }

    }

    func reserveVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback) {

        provider.api.reserveVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

    func cancelReservation(with provider: Provider, completion: @escaping Callback) {

        provider.api.cancelReservation() { response in
            completion(response)
        }

    }

    func openVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback) {

        provider.api.openVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

    func closeVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback) {

        provider.api.closeVehicle(withVIN: vin) { response in
            completion(response)
        }

    }
    
    // MARK: Convenience Getter
    
    func getAllAvailableVehicles(around location: Location?, completion: @escaping Callback) {
        
        guard let location = location else {
            Debug.print(.error(source: .location(Source()), message: "No Location provided"))
            return
        }
        
        var allVehicles: [Vehicle] = []
        
        getAvailableVehicles(from: .driveNow, around: location) { response in
            guard let driveNowVehicles: [Vehicle] = response.getDetails() else { return }
            
            allVehicles.append(contentsOf: driveNowVehicles)
            
            self.getAvailableVehicles(from: .car2go, around: location) { response in
                guard let car2goVehicles: [Vehicle] = response.getDetails() else { return }
                
                allVehicles.append(contentsOf: car2goVehicles)
                let callback = APICallResult.vehicles(allVehicles)
                completion(callback)
            }
        }
    }

}

// MARK: - Default Implementations
extension LogicProtocol {
    
    func login(with provider: Provider, as username: String? = nil, withPassword password: String? = nil, completion: @escaping Callback) {
        login(with: provider, as: username, withPassword: password, completion: completion)
    }
    
    func getAvailableVehicles(from provider: Provider, around location: Location? = nil, completion: @escaping Callback) {
        if let customLocation = location {
            getAvailableVehicles(from: provider, around: customLocation, completion: completion)
        } else {
            let userLocation = getLastKnownUserLocation()
            getAvailableVehicles(from: provider, around: userLocation, completion: completion)
        }
    }
    
    func getAllAvailableVehicles(around location: Location? = nil, completion: @escaping Callback) {
        if let customLocation = location {
            getAllAvailableVehicles(around: customLocation, completion: completion)
        } else {
            let userLocation = getLastKnownUserLocation()
            getAllAvailableVehicles(around: userLocation, completion: completion)
        }
    }
    
}
