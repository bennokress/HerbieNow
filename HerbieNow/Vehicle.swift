//
//  Vehicle.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

// struct, because it makes sense for a vehicle to be called by value (and therefore copied, when assigned to a variable)
struct Vehicle {

    // Attributes provided by API
    let provider: Provider
    let name: String
    let vin: String
    let fuelLevel: Int
    let fuelType: Character
    let address: Location
    
    // Computed Properties from VIN - Optional can be nil, if unknown
    let make: String
    let model: String
    let hp: Int?
    let hasHiFiSystem: Bool?
    let isConvertible: Bool?
    
    // TODO: init with attributes by API

}
