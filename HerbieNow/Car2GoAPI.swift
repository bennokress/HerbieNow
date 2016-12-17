//
//  Car2GoAPI.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

class Car2GoAPI {

    // Singleton - call via Car2GoAPI.shared
    static var shared = Car2GoAPI()
    private init() {}

}

extension Car2GoAPI: API {

    func login() {

    }

    func getUserData() {

    }

    func getReservationStatus() {

    }

    func getAvailableVehicles(around latitude: Double, _ longitude: Double) {

    }

    func reserveVehicle(withVIN vin: String) {

    }

    func cancelReservation() {

    }

    func openVehicle(withVIN vin: String) {

    }

    func closeVehicle(withVIN vin: String) {

    }

}
