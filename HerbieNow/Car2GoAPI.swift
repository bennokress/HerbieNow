//
//  Car2GoAPI.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import Alamofire
import JASON

class Car2GoAPI {

    typealias callback = (APICallResult) -> ()

    let keychain = KeychainService.shared
    let userDefaults = UserDefaultsService.shared
    let provider = Provider.car2go

    // Singleton - call via Car2GoAPI.shared
    static var shared = Car2GoAPI()
    private init() {}

}

extension Car2GoAPI: API {

    func login(completion: @escaping callback) {

    }

    func getUserData(completion: @escaping callback) {

    }

    func getReservationStatus(completion: @escaping callback) {

    }

    func getAvailableVehicles(around location: Location, completion: @escaping callback) {

    }

    func reserveVehicle(withVIN vin: String, completion: @escaping callback) {

    }

    func cancelReservation(completion: @escaping callback) {

    }

    func openVehicle(withVIN vin: String, completion: @escaping callback) {

    }

    func closeVehicle(withVIN vin: String, completion: @escaping callback) {

    }

}
