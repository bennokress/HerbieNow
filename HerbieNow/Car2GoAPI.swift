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
    let test = 1

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
            let transmissionChar = json["engineType"].character
            else {
                return nil
        }
        var licensePlateValue:String?=nil
        var locationValue:Location?=nil

        if let licensePlate = json["name"].string {
            licensePlateValue = licensePlate
        } else if let licensePlate = json["numberPlate"].string {
            licensePlateValue = licensePlate
        } else {
            return nil
        }

        guard let license = licensePlateValue else {
            print(Debug.error(source: (name(of: self), #function), message: "License Plate not Detected"))
            return nil
        }

        if let latitude = json["coordinates"][1].double, let longitude = json["coordinates"][0].double {
            print("Optional1")
            locationValue = Location(latitude: latitude, longitude: longitude)
        } else if let latitude = json["position"]["latitude"].double, let longitude = json["position"]["longitude"].double {
            print("Option2")
            locationValue = Location(latitude: latitude, longitude: longitude)
        } else {
            return nil
        }
        guard let location = locationValue else {
            print(Debug.error(source: (name(of: self), #function), message: "Convertaion for Coordinates failed."))
            return nil
        }

        // TODO Hier noch nicht fertig
        // Hier muss über die VIN eine abfrage gemacht werden
        let fuelType = FuelType(fromRawValue: "P")
        let transmissionType = TransmissionType(fromRawValue: transmissionChar)

        return Vehicle(provider: car2go,
                       vin: vin,
                       fuelLevel: fuelLevelInPercent,
                       fuelType: fuelType,
                       transmissionType: transmissionType,
                       licensePlate: license,
                       location: location
        )
    }

    fileprivate func getReservationFromJSON(_ json:JSON) -> Reservation? {
        guard let startTime = json["reservationTime"]["timeInMillis"].double,
            let vehicle = getVehicleFromJSON(json["vehicle"]) else {
                return nil
        }

        let endTime = (startTime + 30*60*1000) // add 30 min Reservation Time
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

        let functionName = funcID(class: self, func:#function)

        authorizeHerbieNowForCar2Go() { response in

            if let credential: OAuthSwiftCredential = response.getDetails() {
                print(Debug.success(source: (name(of: self), #function), message: "User is logged in."))
                completion(.credential(credential))
            } else {
                completion(.error(code: 0, codeDetail: "no_credentials", message: "Response did not contain Credentials", parentFunction: functionName))
            }

        }

    }

    func getUserData(completion: @escaping Callback) {

        let functionName = funcID(class: self, func:#function)

        getNearestCity(to: appData.getUserLocation()) { cityString in

            let url = "https://www.car2go.com/api/v2.1/accounts?loc=\(cityString.replaceGermanCharacters())&format=\(self.format)"

            self.getOAuthSessionManager() { sessionManager in

                guard let AlamofireWithOAuth = sessionManager else {
                    let error = APICallResult.error(code: 0, codeDetail: "not_logged_in", message: "No user credentials stored for Car2Go!", parentFunction: functionName)
                    completion(error)
                    return
                }

                AlamofireWithOAuth.request(url, method: .get, encoding: URLEncoding.default).responseJASON { callback in

                    let response: APICallResult

                    if let json = callback.result.value {

                        guard let userID = json["account"][0]["accountId"].int else {
                            response = self.errorDetails(code: 0, status: "accountID_not_found", message: "No AccountID in JSON Response found.", in: functionName)
                            completion(response)
                            return
                        }

                        self.appData.addUserID(userID.toString(), for: .car2go)

                    } else {
                        response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
                    }

                }

            }

        }

    }

    func getReservationStatus(completion: @escaping Callback) {
        let functionName = funcID(class: self, func:#function)

        let url = "https://www.car2go.com/api/v2.1/bookings?format=\(self.format)&test=\(self.test)"

        self.getOAuthSessionManager() { sessionManager in

            guard let AlamofireWithOAuth = sessionManager else {
                let error = APICallResult.error(code: 0, codeDetail: "not_logged_in", message: "No user credentials stored for Car2Go!", parentFunction: functionName)
                completion(error)
                return
            }

            AlamofireWithOAuth.request(url, method: .get, encoding: URLEncoding.default).responseJASON { callback in

                let response: APICallResult

                if let json = callback.result.value {
                    guard let bookingArray = json["booking"].jsonArray else {
                        response = self.errorDetails(code: 0, status: "Car2Go", message: "Request is gone false", in: functionName)
                        completion(response)
                        return
                    }

                    let userHasActiveReservation = (bookingArray.count > 0) ? true : false
                    let reservation = userHasActiveReservation ? (self.getReservationFromJSON(bookingArray[0])) : nil

                    response = .reservation(active: userHasActiveReservation, reservation: reservation)

                } else {
                    response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
                }
                completion(response)
            }

        }

    }

    func getAvailableVehicles(around location: Location, completion: @escaping Callback) {

        let functionName = funcID(class: self, func:#function)

        getNearestCity(to: location) { cityString in

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

    func getNearestCity(to userLocation: Location?, completion: @escaping (_ city: String) -> Void) {

        guard let userLocation = userLocation else {
            completion("München")
            return
        }

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
                        if nearestCity.getDistance(from: userLocation.asObject) > city.getDistance(from: userLocation.asObject) {
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

        let functionName = funcID(class: self, func:#function)

        getNearestCity(to: appData.getUserLocation()) { cityString in

            let url = "https://www.car2go.com/api/v2.1/bookings?format=\(self.format)&test=\(self.test)&vin=\(vin)&account=\(self.appData.getUserID(for: .car2go))"

            self.getOAuthSessionManager() { sessionManager in

                guard let AlamofireWithOAuth = sessionManager else {
                    let error = APICallResult.error(code: 0, codeDetail: "not_logged_in", message: "No user credentials stored for Car2Go!", parentFunction: functionName)
                    completion(error)
                    return
                }

                AlamofireWithOAuth.request(url, method: .get, encoding: URLEncoding.default).responseJASON { callback in

                    let response: APICallResult

                    if let json = callback.result.value {
                        guard let bookingArray = json["booking"].jsonArray else {
                            response = self.errorDetails(code: 0, status: "Car2Go", message: "Request is gone false", in: functionName)
                            completion(response)
                            return
                        }

                        let userHasActiveReservation = (bookingArray.count > 0) ? true : false

                        response = .success(userHasActiveReservation)

                    } else {
                        response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
                    }
                    completion(response)
                }

            }

        }

    }

    func cancelReservation(completion: @escaping Callback) {
        let functionName = funcID(class: self, func:#function)

        var url = "https://www.car2go.com/api/v2.1/bookings?format=\(self.format)&test=\(self.test)"

        self.getOAuthSessionManager() { sessionManager in

            guard let AlamofireWithOAuth = sessionManager else {
                let error = APICallResult.error(code: 0, codeDetail: "not_logged_in", message: "No user credentials stored for Car2Go!", parentFunction: functionName)
                completion(error)
                return
            }

            AlamofireWithOAuth.request(url, method: .get, encoding: URLEncoding.default).responseJASON { callback in

                var response: APICallResult

                if let json = callback.result.value {
                    guard let bookingArray = json["booking"].jsonArray else {
                        response = self.errorDetails(code: 0, status: "Car2Go", message: "Request is gone false 1", in: functionName)
                        completion(response)
                        return
                    }

                    let userHasActiveReservation = (bookingArray.count > 0) ? true : false

                    if userHasActiveReservation {
                        let bookingID = bookingArray[0]["bookingId"]
                        url="https://www.car2go.com/api/v2.1/booking/\(bookingID)"
                        response = .success(true)

                        AlamofireWithOAuth.request(url, method: .get, encoding: URLEncoding.default).responseJASON { callback in

                            guard let bookingStatus = json["returnValue"]["code"].int else {
                                response = self.errorDetails(code: 0, status: "Car2Go", message: "CancleRequest is gone false 2", in: functionName)
                                completion(response)
                                return
                            }
                            var cancleRequest:Bool

                            if bookingStatus == 0 {
                                cancleRequest=true
                            } else {
                                cancleRequest=false
                            }

                            response = .success(cancleRequest)

                        }
                    } else {
                        response = .success(true) //Keine Aktive Reservierung vorhanden
                    }

                } else {
                    response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
                }

                completion(response)
            }

        }

    }

    func openVehicle(withVIN vin: String, completion: @escaping Callback) {
        /*Not given in Car2go*/

    }

    func closeVehicle(withVIN vin: String, completion: @escaping Callback) {
        /*Not given in Car2go*/

    }

}
