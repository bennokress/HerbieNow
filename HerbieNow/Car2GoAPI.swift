//
//  Car2GoAPI.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import JASON

class Car2GoAPI {

    typealias Callback = (APICallResult) -> Void

    let appData: AppDataProtocol = AppData.shared
    let car2go = Provider.car2go

    let consumerKey = "HerbyNow"
    let consumerSecret = "e1t9zimQmxmGrJ9eoMaq"
    let format = "json"

    let oauthswift: OAuth1Swift

    var credential: OAuthSwiftCredential? {
        if let token = appData.getOAuthToken(for: car2go), let secret = appData.getOAuthTokenSecret(for: car2go) {
            let oauthCredential = OAuthSwiftCredential(consumerKey: consumerKey, consumerSecret: consumerSecret)
            oauthCredential.oauthToken = token
            oauthCredential.oauthTokenSecret = secret
            return oauthCredential
        } else {
            return nil
        }
    }

    // Singleton - call via Car2GoAPI.shared
    static var shared = Car2GoAPI()
    private init() {
        oauthswift = OAuth1Swift(
            consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            requestTokenUrl: "https://www.car2go.com/api/reqtoken",
            authorizeUrl:    "https://www.car2go.com/api/authorize",
            accessTokenUrl:  "https://www.car2go.com/api/accesstoken"
        )
    }

    fileprivate func authorizeHerbieNowForCar2Go(completion: @escaping Callback) {

        oauthswift.authorize(
            withCallbackURL: "oob",
            success: { credential, _, _ in
                self.appData.addOAuthToken(credential.oauthToken, for: self.car2go)
                self.appData.addOAuthTokenSecret(credential.oauthTokenSecret, for: self.car2go)
                completion(.credential(credential))
        },
            failure: { error in
                completion(.error(code: 0, codeDetail: "not_authorized", message: "The user has not authorized HerbieNow for his Car2Go Account.", parentFunction: #function))
        }
        )

    }

    fileprivate func getOAuthSessionManager(completion: @escaping (SessionManager?) -> Void) {
        let oauthSessionManager = SessionManager.default
        if let savedCredential = credential {
            print(savedCredential.oauthToken)
            print(savedCredential.oauthTokenSecret)
            oauthswift.client.credential.oauthToken = savedCredential.oauthToken
            oauthswift.client.credential.oauthTokenSecret = savedCredential.oauthTokenSecret
            oauthSessionManager.adapter = OAuthSwiftRequestAdapter(oauthswift)
            completion(oauthSessionManager)
        } else {
            authorizeHerbieNowForCar2Go() { response in
                guard let newCredential: OAuthSwiftCredential = response.getDetails() else {
                    completion(nil)
                    return
                }
                self.oauthswift.client.credential.oauthToken = newCredential.oauthToken
                self.oauthswift.client.credential.oauthTokenSecret = newCredential.oauthTokenSecret
                oauthSessionManager.adapter = self.oauthswift.requestAdapter
                completion(oauthSessionManager)
            }
        }
    }

    fileprivate func getVehicleFromJSON(_ json: JSON) -> Vehicle? {
        guard let vin = json["vin"].string,
            let fuelLevelInPercent = json["fuel"].int,
            let transmissionChar = json["engineType"].character,
            let licensePlate = json["name"].string,
            let latitude = json["coordinates"][1].double,
            let longitude = json["coordinates"][0].double
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

    fileprivate func errorDetails(code: Int, status: String, message: String, in function: String) -> APICallResult {
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

        authorizeHerbieNowForCar2Go() { response in

            if let credential: OAuthSwiftCredential = response.getDetails() {
                print(Debug.success(source: (name(of: self), #function), message: "User is logged in."))
                completion(.credential(credential))
            } else {
                completion(.error(code: 0, codeDetail: "no_credentials", message: "Response did not contain Credentials", parentFunction: #function))
            }

        }

    }

    func getUserData(completion: @escaping Callback) {

        let url = "https://www.car2go.com/api/v2.1/accounts?oauth_consumer_key=\(consumerKey)&format=\(format)"

        getOAuthSessionManager() { sessionManager in

            guard let AlamofireWithOAuth = sessionManager else {
                let error = APICallResult.error(code: 0, codeDetail: "not_logged_in", message: "No user credentials stored for Car2Go!", parentFunction: #function)
                completion(error)
                return
            }

            let request = AlamofireWithOAuth.request(url, method: .get, encoding: URLEncoding.default).response { callback in

                print(callback.response ?? "No response")
                //                let response: APICallResult
                //
                //                if let json = callback.result.value {
                //
                //                    guard let accountID = json["account"][0]["accountId"].int else {
                //                        response = self.errorDetails(code: 0, status: "accountID_not_found", message: "No AccountID in JSON Response found.", in: #function)
                //                        completion(response)
                //                        return
                //                    }
                //
                //                    // TODO: save accountID to keychain
                //                    print(accountID)
                //
                //                } else {
                //                    response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: #function)
                //                }
            }

            debugPrint(request)

        }

    }

    func getReservationStatus(completion: @escaping Callback) {

    }

    func getAvailableVehicles(around location: Location, completion: @escaping Callback) {

        let functionName = funcID(class: self, func:#function)

        getNearestCity(actualLocation: location) { cityString in

            let url = "https://www.car2go.com/api/v2.1/vehicles?loc=\(cityString.replaceGermanCharacters())&oauth_consumer_key=\(self.consumerKey)&format=\(self.format)"

            Alamofire.request(url, method: .get, encoding: URLEncoding.default).responseJASON { callback in

                let response: APICallResult

                if let json = callback.result.value {

                    var vehicles: [Vehicle] = []

                    guard let jsonVehicles = json["placemarks"].jsonArray else {
                        response = self.errorDetails(code: 0, status: "vehicles_not_found", message: "No Vehicles in JSON Response found.", in: #function)
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

    }

    func getNearestCity (actualLocation location: Location, completion: @escaping (_ city: String) -> Void) {

        let url = "https://www.car2go.com/api/v2.1/locations?oauth_consumer_key=\(consumerKey)&format=\(format)"

        Alamofire.request(url, method: .get, encoding: URLEncoding.default).responseJASON { callback in

            let fallbackCityName = "München"

            if let json = callback.result.value {

                var cities: [Location] = []

                guard let jsonCities = json["location"].jsonArray else {
                    completion(fallbackCityName)
                    return
                }

                for jsonCity in jsonCities {
                    if let city = self.getCityFromJSON(jsonCity) {
                        cities.append(city)
                    }
                }

                if cities.count > 0 {

                    var nearestCity: Location = cities[0]

                    for city in cities {
                        if nearestCity.getDistance(from: location.asObject) > city.getDistance(from: location.asObject) {
                            nearestCity = city
                        }
                    }

                    completion(nearestCity.car2goCityName ?? fallbackCityName)

                } else {
                    completion(fallbackCityName)
                }

            } else {
                completion(fallbackCityName)
            }

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
