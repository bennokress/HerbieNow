//
//  DriveNowAPI.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

class DriveNowAPI {

    // Singleton - call via DriveNowAPI.shared
    static var shared = DriveNowAPI()
    private init() {}

}

extension DriveNowAPI: API {

    func login(as username: String, withPassword password: String) {

    }

    func getUserData() {

    }

    func getReservationStatus() {

    }

    func getAvailableVehicles() {

    }

    func reserveVehicle() {

    }

    func cancelReservation() {

    }

    func openVehicle() {

    }

    func closeVehicle() {

    }

}
