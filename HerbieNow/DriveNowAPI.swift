//
//  DriveNowAPI.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import Alamofire
import JASON

class DriveNowAPI {

    typealias Callback = (APICallResult) -> Void

    let appData: AppDataProtocol = AppData.shared
    let driveNow = Provider.driveNow

    let apiKey: String
    let language: String
    var metrowsHeaders: HTTPHeaders
    var api2Headers: HTTPHeaders

    // Singleton - call via DriveNowAPI.shared
    static var shared = DriveNowAPI()
    private init() {

        apiKey = "hfh1ukf765iutqed4mvilmbzfexdywak"
        language = "de"

        let baseHeaders = [
            "accept": "application/json;v=1.9",
            "accept-language": language,
            "x-api-key": "adf51226795afbc4e7575ccc124face7",
            "User-Agent" : "DriveNow/3.16.1 (iPhone; iOS 10.2; Scale/3.00)",
            "accept-encoding": "gzip, deflate",
            "apikey": apiKey,
            "connection": "keep-alive"
        ]

        metrowsHeaders = baseHeaders
            .appending("metrows.drive-now.com", forKey: "host")
            .appending("mmkp=cAdEsw6k", forKey: "cookie")
            .appending("application/x-www-form-urlencoded", forKey: "content-type")

        api2Headers = baseHeaders
            .appending("api2.drive-now.com", forKey: "host")

    }

    fileprivate func getVehicleFromJSON(_ json: JSON) -> Vehicle? {

        // swiftlint:disable:next line_length
        guard let vin = json["id"].string, let fuelLevel = json["fuelLevel"].double, let fuelChar = json["fuelType"].character, let transmissionChar = json["transmission"].character, let licensePlate = json["licensePlate"].string, let latitude = json["latitude"].double, let longitude = json["longitude"].double else {
            return nil
        }

        let fuelLevelInPercent = fuelLevel.inPercent()
        let fuelType = FuelType(fromRawValue: fuelChar)
        let transmissionType = TransmissionType(fromRawValue: transmissionChar)
        let location = Location(latitude: latitude, longitude: longitude)

        return Vehicle(provider: .driveNow, vin: vin, fuelLevel: fuelLevelInPercent, fuelType: fuelType, transmissionType: transmissionType, licensePlate: licensePlate, location: location)
    }

    fileprivate func getReservationFromJSON(_ json: JSON) -> Reservation? {

        guard let endTime = json["reservedUntil"].string?.toDate(), let vehicle = getVehicleFromJSON(json["car"]) else {
            return nil
        }

        return Reservation(provider: driveNow, endTime: endTime, vehicle: vehicle)

    }

    fileprivate func errorDetails(for json: JSON, in function: String) -> APICallResult {

        let error: APICallResult

        if let code = json["code"].int, let codeDetail = json["codeDetail"].string, let message = json["message"].string {
            error = .error(code: code, codeDetail: codeDetail, message: message, parentFunction: function)
        } else if let status = json["status"].string {
            error = .error(code: 0, codeDetail: status, message: "Error reported by DriveNow!", parentFunction: function)
        } else {
            error = .error(code: 0, codeDetail: "response_content_error", message: "Wrong variables and/or variable types in response!", parentFunction: function)
        }

        return error

    }

}

extension DriveNowAPI: API {

    func login(completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let username = appData.getUsername(for: driveNow), let password = appData.getPassword(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow Username and / or the password are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v3/user/login"

        let parameters: Parameters = [
            "apikey" : apiKey,
            "language" : language,
            "user" : username,
            "password" : password
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard let xAuthToken = json["auth"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                self.appData.addXAuthToken(xAuthToken, for: self.driveNow)
                let success = true
                response = .success(success)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    func getUserData(completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token is missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/legacy/user"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language
        ]

        Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard let openCarToken = json["attributes"]["opencar"]["token"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                self.appData.addOpenCarToken(openCarToken, for: self.driveNow)
                let success = true
                response = .success(success)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    func getReservationStatus(completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow), let openCarToken = appData.getOpenCarToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/user/status"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "openCarToken" : openCarToken,
            "waitForPending" : "1"
        ]

        Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard json["reservation"]["status"].string != nil else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                let reservation = self.getReservationFromJSON(json["reservation"])
                let userHasActiveReservation = (reservation != nil) ? true : false

                response = .reservation(active: userHasActiveReservation, reservation: reservation)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    func getAvailableVehicles(around location: Location, completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        let url = "https://api2.drive-now.com/cities"

        let parameters: Parameters = [
            "expand" : "full",
            "expandNearestCity" : "1",
            "language" : language,
            "latitude" : "\(location.latitude)",
            "longitude" : "\(location.longitude)",
            "onlyCarsNotInParkingSpace" : "1"
        ]

        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: api2Headers).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                var vehicles: [Vehicle] = []

                guard let jsonVehicles = json["items"][0]["cars"]["items"].jsonArray else {
                    response = self.errorDetails(for: json, in: functionName)
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

    func reserveVehicle(withVIN vin: String, completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow), let openCarToken = appData.getOpenCarToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v2/reservation/request"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "carId" : vin,
            "language" : language,
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard let reservationStatus = json["status"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                let successfullyReserved = (reservationStatus == "reservation_sent" || reservationStatus == "reserved") ? true : false
                response = .success(successfullyReserved)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    func cancelReservation(completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow), let openCarToken = appData.getOpenCarToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/reservation/cancel"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard let reservedUntil = json["reserveduntil"].string?.toDate(), let systemTime = json["systemTime"].string?.toDate() else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                let successfullyCanceled = (reservedUntil <= systemTime) ? true : false
                response = .success(successfullyCanceled)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    func openVehicle(withVIN vin: String, completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow), let openCarToken = appData.getOpenCarToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/open"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard let success = json["success"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                let successfullyOpened = (success == "success") ? true : false
                response = .success(successfullyOpened)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    func closeVehicle(withVIN vin: String, completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow), let openCarToken = appData.getOpenCarToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/close"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard let success = json["success"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                let successfullyClosed = (success == "success") ? true : false
                response = .success(successfullyClosed)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    // This is just in case DriveNow decides to remove the legacy version used in getUserData(), which returns far more information
    private func getUserDataNewVersion(completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow), let openCarToken = appData.getOpenCarToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v3/user"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {
                // TODO: What do we want from this?
                print(json)
                let succesfullyGotDetails = true
                response = .success(succesfullyGotDetails)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

    // This is just in case DriveNow decides to remove the legacy version of getUserData(), which returns the present openCarToken and makes this call unnecessary
    private func getOpenCarToken(for cardNumber: String, completion: @escaping Callback) {

        let functionName = funcID(class: self, func: #function)

        guard let xAuthToken = appData.getXAuthToken(for: driveNow) else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token is missing in Keychain!", parentFunction: functionName)
            completion(error)
            return
        }

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/user/opencar"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "device" : "HerbieNow iPhone",
            "secret" : cardNumber
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {

                guard let openCarToken = json["token"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    completion(response)
                    return
                }

                self.appData.addOpenCarToken(openCarToken, for: self.driveNow)
                let successfullyRegisteredDevice = true
                response = .success(successfullyRegisteredDevice)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            completion(response)

        }

    }

}
