//
//  Logic.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol LogicProtocol {

    typealias callback = (APICallResult) -> ()

    // This protocol contains every function, every […]ViewInterpreter can call.

    func getConfiguredAccounts() -> [Account]

    func getConfiguredFiltersets() -> [Int : Filterset]

    func isAccountConfigured(for provider: Provider) -> Bool

    func getFilterset(for id: Int) -> Filterset?

    // MARK: - API Methods

    func login(with provider: Provider, as username: String, withPassword password: String, completion: @escaping callback)
    func getUserData(from provider: Provider, completion: @escaping callback)
    func getReservationStatus(from provider: Provider, completion: @escaping callback)
    func getAvailableVehicles(from provider: Provider, around location: Location, completion: @escaping callback)
    func reserveVehicle(withVIN vin: String, of provider: Provider, completion: @escaping callback)
    func cancelReservation(with provider: Provider, completion: @escaping callback)
    func openVehicle(withVIN vin: String, of provider: Provider, completion: @escaping callback)
    func closeVehicle(withVIN vin: String, of provider: Provider, completion: @escaping callback)

}

// Logic can do everything inside the Model-Part of the app, but never call anything inside View or Controller
class Logic {

    typealias callback = (APICallResult) -> ()

    let user = User.shared
    let userDefaults = UserDefaultsService.shared
    let keychain = KeychainService.shared

}

extension Logic: LogicProtocol {

    func getConfiguredAccounts() -> [Account] {

        // TODO: Account-Daten abfragen und zurückgeben. Wenn kein Account konfiguriert ist, wird ein leeres Array zurückgegeben.
        return []

    }

    func getConfiguredFiltersets() -> [Int : Filterset] {

        // TODO: Filtersets abfragen und zurückgeben als Dictionary mit Set-Nummer 1-9 und Filterset.
        return [:]

    }

    func isAccountConfigured(for provider: Provider) -> Bool {
        return user.hasConfiguredAccount(for: provider)
    }

    func getFilterset(for id: Int) -> Filterset? {

        // TODO: Filterset holen, falls konfiguriert, sonst nil zurückgeben.
        return nil

    }

    func logout(of provider:Provider) {

        userDefaults.deleteUsername(for: provider)
        keychain.deletePassword(for: provider)
        keychain.deleteXAuthToken(for: provider)
        keychain.deleteOpenCarToken(for: provider)

    }

    // MARK: - API Methods

    // TODO: Closures zu allen API Calls hinzufügen

    func login(with provider: Provider, as username: String, withPassword password: String, completion: @escaping callback) {

        userDefaults.addUsername(username, for: provider)
        keychain.addPassword(password, for: provider)

        let api = provider.api()
        api.login() { response in
            completion(response)
        }

    }

    func getUserData(from provider: Provider, completion: @escaping callback) {

        let api = provider.api()
        api.getUserData() { response in
            completion(response)
        }

    }

    func getReservationStatus(from provider: Provider, completion: @escaping callback) {

        let api = provider.api()
        api.getReservationStatus() { response in
            completion(response)
        }

    }

    func getAvailableVehicles(from provider: Provider, around location: Location, completion: @escaping callback) {

        let api = provider.api()
        api.getAvailableVehicles(around: location) { response in
            completion(response)
        }

    }

    func reserveVehicle(withVIN vin: String, of provider: Provider, completion: @escaping callback) {

        let api = provider.api()
        api.reserveVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

    func cancelReservation(with provider: Provider, completion: @escaping callback) {

        let api = provider.api()
        api.cancelReservation() { response in
            completion(response)
        }

    }

    func openVehicle(withVIN vin: String, of provider: Provider, completion: @escaping callback) {

        let api = provider.api()
        api.openVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

    func closeVehicle(withVIN vin: String, of provider: Provider, completion: @escaping callback) {

        let api = provider.api()
        api.closeVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

}
