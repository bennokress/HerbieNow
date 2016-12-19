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

    let provider: Provider
    let vin: String
    let fuelLevel: Int
    let fuelType: Character
    let transmissionType: Character
    let licensePlate: String
    let address: Location
    let make: String?
    let model: String?
    let hp: Int?
    let hasHiFiSystem: Bool?
    let isConvertible: Bool?
    
    init(provider: Provider, vin: String, fuelLevel: Int, fuelType: Character, transmissionType: Character, licensePlate: String, address: Location) {
        
        // from API
        self.provider = provider
        self.vin = vin
        self.fuelLevel = fuelLevel
        self.fuelType = fuelType
        self.transmissionType = transmissionType
        self.licensePlate = licensePlate
        self.address = address
        
        // computed from vehicle identification number
        self.make = vin.make
        self.model = vin.model
        self.hp = vin.hp
        self.hasHiFiSystem = vin.hasHiFiSystem
        self.isConvertible = vin.isConvertible
        
    }

}
