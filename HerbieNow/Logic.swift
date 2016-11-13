//
//  Logic.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol LogicProtocol {
    
    func login(at provider: Provider)
    func getUserData(from provider: Provider)
    func getReservationStatus(from provider: Provider)
    func getAvailableVehicles(from provider: Provider)
    func reserveVehicle(at provider: Provider)
    
}

// Logic can do everything inside the Model-Part of the app, but never call anything inside View or Controller
class Logic {
    
    
    
}

extension Logic: LogicProtocol {
    
    func login(at provider: Provider) {
        <#code#>
    }
    
    func getUserData(from provider: Provider) {
        <#code#>
    }
    
    func getReservationStatus(from provider: Provider) {
        <#code#>
    }
    
    func getAvailableVehicles(from provider: Provider) {
        <#code#>
    }
    
    func reserveVehicle(at provider: Provider) {
        <#code#>
    }
    
}
