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
    let car2go = Provider.car2go

    let consumerKey: String
    let consumerKeySecret: String
    let format: String
    let language: String
    var apiHeader: HTTPHeaders

    // Singleton - call via Car2GoAPI.shared
    static var shared = Car2GoAPI()
    private init() {
        consumerKeySecret = "e1t9zimQmxmGrJ9eoMaq"
        consumerKey = "HerbyNow"
        language = "de"
        format = "json"
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
            let fuelLevelInPercent = json["fuel"].int,
            let transmissionChar = json["engineType"].character,
            let licensePlate = json["name"].string,
            let latitude = json["coordinates"][0].double,
            let longitude = json["coordinates"][1].double
            else {
                return nil
        }

        // TODO Hier noch nicht fertig
        // Hier muss über die VIN eine abfrage gemacht werden
        let fuelType = FuelType(fromRawValue: "P")
        let transmissionType = TransmissionType(fromRawValue: transmissionChar)

        let location = Location(latitude: latitude, longitude: longitude)

        return Vehicle(provider: car2go,
                       vin: vin,
                       fuelLevel: fuelLevelInPercent,
                       fuelType: fuelType,
                       transmissionType: transmissionType,
                       licensePlate: licensePlate,
                       location: location
        )
    }

    fileprivate func getReservationFromJSON(_ json:JSON) -> Reservation? {
        guard let startTime = json["reservationTime"]["timeInMillis"].double,
            let vehicle = getVehicleFromJSON(json["vehicle"]) else {
                return nil
        }

        let endTime = (startTime + 1800*1000) // add 30 min Reservation Time
        let endDate = Date(unixTimestamp: endTime)

        return Reservation(provider: car2go, endTime: endDate, vehicle: vehicle)
    }

    fileprivate func errorDetails(for message: String, with code: Int, and status: String, in function: String) -> APICallResult {
        let error: APICallResult
        error = .error(code: code, codeDetail: status, message: message, parentFunction: function)
        return error
    }
    
    fileprivate func getCityFromJSON(_ json: JSON) -> Location? {
        guard let name = json["locationName"].string,
            let longitude = json["mapSection"]["center"]["longitude"].double,
            let latitude = json["mapSection"]["center"]["latitude"].double
            else {
                return nil
            
        }
        return Location(latitude: latitude, longitude: longitude, car2goCityName: name)
    }
}

extension Car2GoAPI: API {

    func login(completion: @escaping Callback) {
        let functionName = name(of: self)+"."+#function
        guard let _ = appData.getUsername(for: car2go), let _ = appData.getPassword(for: car2go) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The Car2Go Username and / or the password are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

    }

    func getUserData(completion: @escaping Callback) {

    }

    func getReservationStatus(completion: @escaping Callback) {

    }

    func getAvailableVehicles(around location: Location, completion: @escaping Callback) {

        let functionName = funcID(class: self, func:#function)

        // TODO: get nearest Loc from GPS
        let url = "https://www.car2go.com/api/v2.1/vehicles?loc=muenchen&oauth_consumer_key=\(consumerKey)&format=\(format)"

        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: apiHeader).responseJASON {callback in

            let response: APICallResult

            if let json = callback.result.value {

                var vehicles: [Vehicle] = []

                guard let jsonVehicles = json["placemarks"].jsonArray else {
                    response = self.errorDetails(for: "getVIList", with: 0, and: "", in: functionName)
                    completion(response)
                    return
                }

                for jsonVehicle in jsonVehicles {
                    if let vehicle = self.getVehicleFromJSON(jsonVehicle) {
                        vehicles.append(vehicle)
                    }
                }
                response = .vehicles(vehicles)
            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }
            completion(response)
        }
    }
    
    func getNearestCity (actualLocation location: Location , completion: @escaping Callback){
        
        let functionName = funcID(class: self, func:#function)
        
        let url = "http://www.car2go.com/api/v2.1/locations?oauth_consumer_key=\(consumerKey)&format=\(format)"
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: apiHeader).responseJASON{callback in
            
            let response: APICallResult
            
            if let json = callback.result.value{
                var cities: [Location] = []
                
                guard let jsonCities = json["location"].jsonArray else{
                    response = self.errorDetails(for: "getLocationList", with: 0, and: "", in : functionName)
                    completion(response)
                    return
                }
                
                for jsonCity in jsonCities{
                    if let city = self.getCityFromJSON(jsonCity){
                        cities.append(city)
                    }
                }
                
                if !cities.isEmpty{
                    var nearestCity:Location = cities[0]
                    
                    for city in cities{
                        if nearestCity.getDistance(from: location.asObject) > city.getDistance(from: location.asObject) {
                            nearestCity = city
                        }
                    }
                    self.appData.setNearestCar2GoCity(nearestCity.car2goCityName!)
                    response = .error(code: 0, codeDetail: "city_is_set", message: "Nearest City is: " + nearestCity.car2goCityName!, parentFunction: functionName)
                }
                else{
                    response = .error(code: 0, codeDetail: "array_empty_error", message: "The Cityarray is empty!", parentFunction: functionName)
                }
                
            } else{
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }
            completion(response)
        }
        
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
