//
//  Reservation.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.12.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

struct Reservation {
    
    // MARK: Stored Properties
    
    let provider: Provider
    let endTime: Date
    let vehicle: Vehicle
    let description: String

    // MARK: Initialization
    
    init(provider: Provider, endTime: Date, vehicle: Vehicle) {

        self.provider = provider
        self.endTime = endTime
        self.vehicle = vehicle

        description = "Reservation with \(provider.rawValue) for \(vehicle.make.rawValue) \(vehicle.model) (\(vehicle.licensePlate)) active until \(endTime.timeDescription)."

    }

}
