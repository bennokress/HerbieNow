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
    
    func login(with provider: Provider, as username: String, withPassword password: String) {
        
        // TODO: Route calls to correct API
        
    }
    
    func getUserData(from provider: Provider) {
        
        // TODO: Route calls to correct API
        
    }
    
    func getReservationStatus(from provider: Provider) {
        
        // TODO: Route calls to correct API
        
    }
    
    func getAvailableVehicles(from provider: Provider) {
        
        // TODO: Route calls to correct API
        
    }
    
    func reserveVehicle(with provider: Provider) {
        
        // TODO: Route calls to correct API
        
    }
    
    func cancelReservation(with provider: Provider) {
        
        // TODO: Route calls to correct API
        
    }
    
    func openVehicle(with provider: Provider) {
        
        // TODO: Route calls to correct API
        
    }
    
    func closeVehicle(with provider: Provider) {
        
        // TODO: Route calls to correct API
        
    }
    
}
