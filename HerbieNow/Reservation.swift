//
//  Reservation.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

struct Reservation {

    let provider: Provider
    let endTime: Date
    let vehicle: Vehicle
    
    let description: String
    
    init(provider: Provider, endTime: Date, vehicle: Vehicle) {
        
        self.provider = provider
        self.endTime = endTime
        self.vehicle = vehicle
        
        description = "Reservation with \(provider.rawValue) for \(vehicle.make) \(vehicle.model) (\(vehicle.licensePlate)) active until \(endTime.description)."
        
    }

}
