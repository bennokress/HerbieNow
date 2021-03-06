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

    var encodedImage: String {
        return model.encodedImage
    }
    
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
    
    func debugPrint() {
        let fuelingWord = (fuelType == .electric) ? "charged" : "fueled"
        let hifiAddition = hasHiFiSystem ? " • HiFi System" : ""
        let convertibleAddition = isConvertible ? " • Convertible" : ""
        Debug.print(.list(item: "\(provider.rawValue): \(licensePlate)", indent: 1))
        Debug.print(.list(item: "\(make.rawValue) \(model.getString()) • \(hp)HP • \(transmissionType.description)", indent: 2))
        Debug.print(.list(item: "\(location.coordinateDescription)", indent: 2))
        Debug.print(.list(item: "\(fuelLevel)% \(fuelingWord) • \(fuelType.description)", indent: 2))
        Debug.print(.list(item: "\(doors) doors • \(seats) seats\(hifiAddition)\(convertibleAddition)", indent: 2))
    }
    
    var detailsForLine1: String {
        return "\(make.rawValue) \(model.getString()) • \(hp)HP"
    }
    
    var detailsForLine2: String {
        if (fuelType == .electric) {
            return "\(fuelLevel)% charged • \(fuelType.description)"
        }
        return "\(fuelLevel)% fueled • \(fuelType.description)"
    }
    
    var detailsForLine3: String {
        guard let userLocation = AppData.shared.userLocation?.asObject else {
            return ""
        }
        var distance = self.location.getDistance(from: userLocation)
        var distanceInformation = ""
        if (distance < 1000.0) {
            distance = round(distance)
            distanceInformation = String(format: "%.0f", distance) + " m from here"
        } else {
            distance /= 100.0
            distance = round(distance)
            distance /= 10.0
            distanceInformation = "\(distance) km from here"
        }
        return distanceInformation
    }
    
}
