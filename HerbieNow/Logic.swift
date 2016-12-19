//
//  Logic.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol LogicProtocol {

    // This protocol contains every function, every […]ViewInterpreter can call.

    func getConfiguredAccounts() -> [Account]

    func getConfiguredFiltersets() -> [Int : Filterset]

    func isAccountConfigured(for provider: Provider) -> Bool

    func getFilterset(for id: Int) -> Filterset?

    // MARK: - API Methods

    func login(with provider: Provider, as username: String, withPassword password: String)
    func getUserData(from provider: Provider)
    func getReservationStatus(from provider: Provider)
    func getAvailableVehicles(from provider: Provider, around latitude: Double, _ longitude: Double)
    func reserveVehicle(withVIN vin: String, of provider: Provider)
    func cancelReservation(with provider: Provider)
    func openVehicle(withVIN vin: String, of provider: Provider)
    func closeVehicle(withVIN vin: String, of provider: Provider)

}

// Logic can do everything inside the Model-Part of the app, but never call anything inside View or Controller
class Logic {

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

    // MARK: - API Methods

    // TODO: Closures zu allen API Calls hinzufügen

    func login(with provider: Provider, as username: String, withPassword password: String) {

        userDefaults.add(value: username, forKey: "\(provider.rawValue) Username")
        keychain.add(value: password, forKey: "\(provider.rawValue) Password")

        let api = provider.api()
        api.login()

    }

    func logout(of provider:Provider) {

        let api = provider.api()
        api.logout()

    }

    func getUserData(from provider: Provider) {

        let api = provider.api()
        api.getUserData()

    }

    func getReservationStatus(from provider: Provider) {

        let api = provider.api()
        api.getReservationStatus()

    }

    func getAvailableVehicles(from provider: Provider, around latitude: Double, _ longitude: Double) {

        let api = provider.api()
        api.getAvailableVehicles(around: latitude, longitude)

    }

    func reserveVehicle(withVIN vin: String, of provider: Provider) {

        let api = provider.api()
        api.reserveVehicle(withVIN: vin)

    }

    func cancelReservation(with provider: Provider) {

        let api = provider.api()
        api.cancelReservation()

    }

    func openVehicle(withVIN vin: String, of provider: Provider) {

        let api = provider.api()
        api.openVehicle(withVIN: vin)

    }

    func closeVehicle(withVIN vin: String, of provider: Provider) {

        let api = provider.api()
        api.closeVehicle(withVIN: vin)

    }

}
