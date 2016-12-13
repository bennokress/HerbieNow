//
//  API.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol API {

    func login(as username: String, withPassword password: String)
    func getUserData()
    func getReservationStatus()
    func getAvailableVehicles()
    func reserveVehicle(withVIN vin: String)
    func cancelReservation()
    func openVehicle(withVin vin: String)
    func closeVehicle(withVin vin: String)

}
