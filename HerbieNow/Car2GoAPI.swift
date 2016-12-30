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

    let consumerKey: String
    let consumerKeySecret: String
    let language: String
    var apiHeader: HTTPHeaders

    // Singleton - call via Car2GoAPI.shared
    static var shared = Car2GoAPI()
    private init() {
        consumerKeySecret = "e1t9zimQmxmGrJ9eoMaq"
        consumerKey = "HerbyNow"
        language = "de"
        let version: Float
        version = 0.1
        apiHeader = [
            "accept": "application/json;v=1.9",
            "accept-language": language,
            "x-api-key": "adf51226795afbc4e7575ccc124face7",
            "User-Agent" : "HerbyNow \(version) @ LMU",
            "accept-encoding": "gzip, deflate",
            "connection": "keep-alive"
        ]
    }

    fileprivate func getVehicleFromJSON(_ json: JSON) -> Vehicle? {
        guard let vin = json["vin"].string,
            let fuelLevel = json["fuel"].int,
            let transmissionChar = json["engineType"].character,
            let licensePlate = json["name"].string,
            let latitude = json["coordinates"][0].double,
            let longitude = json["coordinates"][1].double
            else {
                return nil
        }

        // TODO Hier noch nicht fertig
        let fuelType = FuelType(fromRawValue: "G")
        let transmissionType = TransmissionType(fromRawValue: transmissionChar)
        let location = Location(latitude: latitude, longitude: longitude)

        return Vehicle(provider: .car2go,
                       vin: vin,
                       fuelLevel: fuelLevel,
                       fuelType: fuelType,
                       transmissionType: transmissionType,
                       licensePlate: licensePlate,
                       location: location
        )
    }

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
