//
//  Vehicle.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import JASON

// struct, because it makes sense for a vehicle to be called by value (and therefore copied, when assigned to a variable)
struct Vehicle {

    let provider: Provider
    let vin: String
    let fuelLevel: Int
    let fuelType: FuelType
    let transmissionType: TransmissionType
    let licensePlate: String
    let location: Location
    let make: Make
    let model: String
    let kW: Int
    let hp: Int
    let hasHiFiSystem: Bool
    let isConvertible: Bool

    let description: String

    // swiftlint:disable:next function_parameter_count
    init(provider: Provider, vin: String, fuelLevel: Int, fuelType: FuelType, transmissionType: TransmissionType, licensePlate: String, location: Location) {

        // from API
        self.provider = provider
        self.vin = vin
        self.fuelLevel = fuelLevel
        self.fuelType = fuelType
        self.transmissionType = transmissionType
        self.licensePlate = licensePlate
        self.location = location

        // computed from vehicle identification number
        self.make = vin.make
        self.model = vin.model
        self.kW = vin.kW
        self.hp = vin.hp
        self.hasHiFiSystem = vin.hasHiFiSystem
        self.isConvertible = vin.isConvertible

        self.description = "\(provider.rawValue): \(licensePlate)\t\tConvertible: \(isConvertible)\t\tHiFi-System: \(hasHiFiSystem)\t\tPower: \(hp)hp \t\(kW)kW \t\t\(location.coordinateDescription)\t\t\(make.rawValue) \(model)"

    }

}

extension Vehicle: Equatable {
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.vin == rhs.vin
    }
    
}
