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
    
    
//    /**
//     Trigger login at specified provider.
//     
//     - Parameters:
//         - provider: Specified provider
//         - successful: Closure, that tells if the login was successful
//     */
//    func login(at provider: Provider, successful: (Bool) -> Void)
//    
//    /// Get user data from the specified provider and save it to the user model.
//    func getUserData(from provider: Provider)
//    
//    /**
//     Look for an active reservation with the specified provider.
//     
//     - Parameters:
//     - provider: Specified provider
//     - userHasActiveReservation: Closure, that tells if the user has an active reservation
//     */
//    func getReservationStatus(from provider: Provider, userHasActiveReservation: (Bool) -> Void)
//    
//    
//    func getAvailableVehicles(from provider: Provider)
//    func reserveVehicle(at provider: Provider)
    
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

}
