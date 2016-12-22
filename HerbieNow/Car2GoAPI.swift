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

    typealias Callback = (APICallResult) -> Void

    let appData: AppDataProtocol = AppData.shared
    let provider = Provider.car2go

    // Singleton - call via Car2GoAPI.shared
    static var shared = Car2GoAPI()
    private init() {}

}

extension Car2GoAPI: API {

    func login(completion: @escaping Callback) {

    }

    func getUserData(completion: @escaping Callback) {

    }

    func getReservationStatus(completion: @escaping Callback) {

    }

    func getAvailableVehicles(around location: Location, completion: @escaping Callback) {

    }

    func reserveVehicle(withVIN vin: String, completion: @escaping Callback) {

    }

    func cancelReservation(completion: @escaping Callback) {

    }

    func openVehicle(withVIN vin: String, completion: @escaping Callback) {

    }

    func closeVehicle(withVIN vin: String, completion: @escaping Callback) {

    }

}
