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

    // This protocol contains every function, every […]ViewInterpreter can call.

    //    func getConfiguredAccounts() -> [Account]

    func getConfiguredFiltersets() -> [Int : Filterset]

    func isAccountConfigured(for provider: Provider) -> Bool

    func getFilterset(for id: Int) -> Filterset?

    // MARK: - API Methods

    func login(with provider: Provider, as username: String?, withPassword password: String?, completion: @escaping Callback)
    func getUserData(from provider: Provider, completion: @escaping Callback)
    func getReservationStatus(from provider: Provider, completion: @escaping Callback)
    func getAvailableVehicles(from provider: Provider, around location: Location, completion: @escaping Callback)
    func reserveVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback)
    func cancelReservation(with provider: Provider, completion: @escaping Callback)
    func openVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback)
    func closeVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback)

    func saveUpdatedLocation(_ location: Location)

}

extension LogicProtocol {

    func login(with provider: Provider, as username: String? = nil, withPassword password: String? = nil, completion: @escaping Callback) {
        login(with: provider, as: username, withPassword: password, completion: completion)
    }

}

// Logic can do everything inside the Model-Part of the app, but never call anything inside View or Controller
class Logic {

    typealias Callback = (APICallResult) -> Void

    let user = User.shared
    let appData: AppDataProtocol = AppData.shared

}

extension Logic: LogicProtocol {

    //    func getConfiguredAccounts() -> [Account] {

    //        // TODO: Account-Daten abfragen und zurückgeben. Wenn kein Account konfiguriert ist, wird ein leeres Array zurückgegeben.
    //        return []

    //    }

    func saveUpdatedLocation(_ location: Location) {
        appData.updateUserLocation(to: location)
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
        appData.deleteCredentials(for: provider)
    }

    // MARK: - API Methods

    // TODO: Closures zu allen API Calls hinzufügen

    func login(with provider: Provider, as username: String?, withPassword password: String?, completion: @escaping Callback) {

        switch provider {
        case .driveNow:
            guard let dnUsername = username, let dnPassword = password else {
                let error = APICallResult.error(code: 0, codeDetail: "no_credentials_provided", message: "No Credentials passed with login call for DriveNow!", parentFunction: #function)
                completion(error)
                return
            }

            appData.addUsername(dnUsername, for: .driveNow)
            appData.addPassword(dnPassword, for: .driveNow)

            let api = provider.api()
            api.login() { response in
                completion(response)
            }
        case .car2go:
            let api = provider.api()
            api.login() { response in
                completion(response)
            }
        }

    }

    func getUserData(from provider: Provider, completion: @escaping Callback) {

        let api = provider.api()
        api.getUserData() { response in
            completion(response)
        }

    }

    func getReservationStatus(from provider: Provider, completion: @escaping Callback) {

        let api = provider.api()
        api.getReservationStatus() { response in
            completion(response)
        }

    }

    func getAvailableVehicles(from provider: Provider, around location: Location, completion: @escaping Callback) {

        let api = provider.api()
        api.getAvailableVehicles(around: location) { response in
            completion(response)
        }

    }

    func reserveVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback) {

        let api = provider.api()
        api.reserveVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

    func cancelReservation(with provider: Provider, completion: @escaping Callback) {

        let api = provider.api()
        api.cancelReservation() { response in
            completion(response)
        }

    }

    func openVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback) {

        let api = provider.api()
        api.openVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

    func closeVehicle(withVIN vin: String, of provider: Provider, completion: @escaping Callback) {

        let api = provider.api()
        api.closeVehicle(withVIN: vin) { response in
            completion(response)
        }

    }

}
