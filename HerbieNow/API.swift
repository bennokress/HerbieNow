//
//  API.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol API {

    func login()
    func getUserData()
    func getReservationStatus()
    func getAvailableVehicles(around latitude: Double, _ longitude: Double)
    func reserveVehicle(withVIN vin: String)
    func cancelReservation()
    func openVehicle(withVIN vin: String)
    func closeVehicle(withVIN vin: String)

}
