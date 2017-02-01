//
//  Vehicle.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import JASON

struct Vehicle {
    
    // MARK: Stored Properties

    let provider: Provider
    let vin: String
    let fuelLevel: Int
    let fuelType: FuelType
    let transmissionType: TransmissionType
    let licensePlate: String
    let location: Location
    let make: Make
    let model: Model
    let kW: Int
    let hp: Int
    let hasHiFiSystem: Bool
    let isConvertible: Bool
    let doors: Int
    let seats: Int
    
    // MARK: Initialization

    init(provider: Provider, vin: String, fuelLevel: Int, fuelType: FuelType, transmissionType: TransmissionType, licensePlate: String, location: Location) {

        // From API (read)
        self.provider = provider
        self.vin = vin
        self.fuelLevel = fuelLevel
        self.fuelType = fuelType
        self.transmissionType = transmissionType
        self.licensePlate = licensePlate
        self.location = location

        // From VIN (computed)
        self.make = vin.make
        self.model = vin.model
        self.kW = vin.kW
        self.hp = vin.hp
        self.hasHiFiSystem = vin.hasHiFiSystem
        self.isConvertible = vin.isConvertible
        self.doors = vin.doors
        self.seats = vin.seats

    }

}

// MARK: - Equatable Conformance
extension Vehicle: Equatable {

    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.vin == rhs.vin
    }

}

// MARK: - Custom String Convertible Conformance
extension Vehicle: CustomStringConvertible {
    
    var description: String {
        return "\(provider.rawValue): \(licensePlate)\t\tConvertible: \(isConvertible)\t\tHiFi-System: \(hasHiFiSystem)\t\tPower: \(hp)hp \t\(kW)kW \t\t\(location.coordinateDescription)\t\t\(make.rawValue) \(model)"
    }
    
    var detailsForLine1: String {
        return "\(make.rawValue) \(model.getString()) • \(hp)HP"
    }
    
    var detailsForLine2: String {
        if(fuelType == .electric) {
            return "\(fuelLevel)% charged • \(fuelType.description())"
        }
        return "\(fuelLevel)% fueled • \(fuelType.description())"
    }
    
    func detailsForLine3() -> String {
        let userLocation = AppData.shared.userLocation?.asObject
        var returnString = "details3 did not work"
        
        self.location.getAddress { (locationData: (street: String, areaCode: String, city: String)?) in
            
            returnString = "\(self.location.getDistance(from: userLocation!))km → \(locationData?.street)"
        }
        return returnString
    }
    
}
