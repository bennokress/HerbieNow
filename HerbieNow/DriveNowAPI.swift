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

    let keychain = KeychainService.shared
    let userDefaults = UserDefaultsService.shared

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

    fileprivate func getSavedUsername() -> String? {
        return userDefaults.findValue(forKey: "DriveNow Username")
    }

    fileprivate func getSavedPassword() -> String? {
        return keychain.findValue(forKey: "DriveNow Password")
    }

    fileprivate func getSavedXAuthToken() -> String? {
        return keychain.findValue(forKey: "DriveNow X-Auth-Token")
    }

    fileprivate func getSavedOpenCarToken() -> String? {
        return keychain.findValue(forKey: "DriveNow Open-Car-Token")
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

    func login() {

        let functionName = "DriveNowAPI.cancelReservation"

        guard let username = getSavedUsername(), let password = getSavedPassword() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow Username in UserDefaults and / or the password in Keychain are missing!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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
                    // TODO: Completion Handling
                    print(response.description)
                    return
                }

                self.keychain.add(value: xAuthToken, forKey: "DriveNow X-Auth-Token")
                response = .success(contents: nil)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    func getUserData() {

        let functionName = "DriveNowAPI.getUserData"

        guard let xAuthToken = getSavedXAuthToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token is missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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
                    // TODO: Completion Handling
                    print(response.description)
                    return
                }

                self.keychain.add(value: openCarToken, forKey: "DriveNow Open-Car-Token")
                response = .success(contents: nil)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    func getReservationStatus() {

        let functionName = "DriveNowAPI.getReservationStatus"

        guard let xAuthToken = getSavedXAuthToken(), let openCarToken = getSavedOpenCarToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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

                let reservation: Reservation?

                guard let reservationStatus = json["reservation"]["status"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    // TODO: Completion Handling
                    print(response.description)
                    return
                }

                print(reservationStatus)

                if reservationStatus == "reservation_active" {
                    // TODO: Get End Time of Reservation as Date
                    // TODO: Get Vehicle Object
                    let endTime = Date()
                    let vehicle = Vehicle()
                    reservation = Reservation(provider: .driveNow, endTime: endTime, vehicle: vehicle)
                } else {
                    reservation = nil
                }

                response = .success(contents: reservation)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    func getAvailableVehicles(around latitude: Double, _ longitude: Double) {

        let functionName = "DriveNowAPI.getAvailableVehicles"

        let url = "https://api2.drive-now.com/cities"

        let parameters: Parameters = [
            "expand" : "full",
            "expandNearestCity" : "1",
            "language" : language,
            "latitude" : "\(latitude)",
            "longitude" : "\(longitude)",
            "onlyCarsNotInParkingSpace" : "1"
        ]

        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: api2Headers).responseJASON { callback in

            let response: APICallResult

            if let json = callback.result.value {
                print("JSON:\n\(json)")
                response = .success(contents: nil)
            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }
    }

    func reserveVehicle(withVIN vin: String) {

        let functionName = "DriveNowAPI.reserveVehicles"

        guard let xAuthToken = getSavedXAuthToken(), let openCarToken = getSavedOpenCarToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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

                let success: Bool

                guard let reservationStatus = json["status"].string else {
                    response = self.errorDetails(for: json, in: functionName)
                    // TODO: Completion Handling
                    print(response.description)
                    return
                }

                success = (reservationStatus == "reservation_sent") ? true : false
                response = .success(contents: success)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    func cancelReservation() {

        let functionName = "DriveNowAPI.cancelReservation"

        guard let xAuthToken = getSavedXAuthToken(), let openCarToken = getSavedOpenCarToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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

                let optionalReservedUntil = json["reserveduntil"].string?.toDate()
                let optionalSystemTime = json["systemTime"].string?.toDate()

                guard let reservedUntil = optionalReservedUntil, let systemTime = optionalSystemTime else {
                    response = self.errorDetails(for: json, in: functionName)
                    // TODO: Completion Handling
                    print(response.description)
                    return
                }

                let successfullyCanceled = (reservedUntil <= systemTime) ? true : false
                response = .success(contents: successfullyCanceled)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    func openVehicle(withVIN vin: String) {

        let functionName = "DriveNowAPI.openVehicle"

        guard let xAuthToken = getSavedXAuthToken(), let openCarToken = getSavedOpenCarToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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
                print(json)
                response = .success(contents: nil)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    func closeVehicle(withVIN vin: String) {

        let functionName = "DriveNowAPI.closeVehicle"

        guard let xAuthToken = getSavedXAuthToken(), let openCarToken = getSavedOpenCarToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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
                print(json)
                response = .success(contents: nil)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    // This is just in case DriveNow decides to remove the legacy version used in getUserData(), which returns far more information
    private func getUserDataNewVersion() {

        let functionName = "DriveNowAPI.getUserDataNewVersion"

        guard let xAuthToken = getSavedXAuthToken(), let openCarToken = getSavedOpenCarToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token and / or Open-Car-Token are missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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
                print(json)
                response = .success(contents: nil)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

    // This is just in case DriveNow decides to remove the legacy version of getUserData(), which returns the present openCarToken and makes this call unnecessary
    private func getOpenCarToken(for cardNumber: String) {

        let functionName = "DriveNowAPI.getReservationStatus"

        guard let xAuthToken = getSavedXAuthToken() else {
            let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The DriveNow X-Auth-Token is missing in Keychain!", parentFunction: functionName)
            // TODO: Completion Handling
            print(error.description)
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
                    // TODO: Completion Handling
                    print(response.description)
                    return
                }

                self.keychain.add(value: openCarToken, forKey: "DriveNow Open-Car-Token")
                response = .success(contents: nil)

            } else {
                response = .error(code: 0, codeDetail: "response_format_error", message: "The response was not in JSON format!", parentFunction: functionName)
            }

            // TODO: Completion Handling
            print(response.description)

        }

    }

}
