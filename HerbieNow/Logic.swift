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
    func getAvailableVehicles(from provider: Provider)
    func reserveVehicle(with provider: Provider)
    func cancelReservation(with provider: Provider)
    func openVehicle(with provider: Provider)
    func closeVehicle(with provider: Provider)

}

// Logic can do everything inside the Model-Part of the app, but never call anything inside View or Controller
class Logic {

    let user = User.shared

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

        // TODO: Nutzername und Passwort speichern --> UserDefaults & Keychain

        let api = provider.api()
        api.login(as: username, withPassword: password)

    }

    func getUserData(from provider: Provider) {

        let api = provider.api()
        api.getUserData()

    }

    func getReservationStatus(from provider: Provider) {

        let api = provider.api()
        api.getReservationStatus()

    }

    func getAvailableVehicles(from provider: Provider) {

        let api = provider.api()
        api.getAvailableVehicles()

    }

    func reserveVehicle(with provider: Provider) {

        let api = provider.api()
        api.reserveVehicle()

    }

    func cancelReservation(with provider: Provider) {

        let api = provider.api()
        api.cancelReservation()

    }

    func openVehicle(with provider: Provider) {

        let api = provider.api()
        api.openVehicle()

    }

    func closeVehicle(with provider: Provider) {

        let api = provider.api()
        api.closeVehicle()

    }

}
