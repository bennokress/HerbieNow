//
//  DriveNowAPI.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }

}

class DriveNowAPI {

    let apiKey: String
    let language: String
    var metrowsHeaders: HTTPHeaders
    var api2Headers: HTTPHeaders

    // TODO: Tokens aus Keychain abrufen
    //    var xAuthToken: String = { return keychain.xAuthToken }
    //    var openCarToken: String = { return keychain.openCarToken }

    let xAuthToken = "XXX"
    let openCarToken = "XXX"

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

}

extension DriveNowAPI: API {

    func login(as username: String, withPassword password: String) {

        let url = "https://metrows.drive-now.com/php/drivenowws/v3/user/login"

        let parameters: Parameters = [
            "apikey" : apiKey,
            "language" : language,
            "user" : username,
            "password" : password
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen
        // TODO: auth als X-Auth-Token in Keychain speichern

    }

    func getUserData() {

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/legacy/user"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language
        ]

        Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen

    }

    func getReservationStatus() {

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/user/status"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "openCarToken" : openCarToken,
            "waitForPending" : "1"
        ]

        Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen

    }

    func getAvailableVehicles(around latitude: Double, _ longitude: Double) {

        let url = "https://api2.drive-now.com/cities"

        let parameters: Parameters = [
            "expand" : "full",
            "expandNearestCity" : "1",
            "language" : language,
            "latitude" : "\(latitude)",
            "longitude" : "\(longitude)",
            "onlyCarsNotInParkingSpace" : "1"
        ]

        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: api2Headers).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen
    }

    func reserveVehicle(withVIN vin: String) {

        let url = "https://metrows.drive-now.com/php/drivenowws/v2/reservation/request"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "carId" : vin,
            "language" : language,
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen

    }

    func cancelReservation() {

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/reservation/cancel"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen

    }

    func openVehicle(withVIN vin: String) {

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/open"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen

    }

    func closeVehicle(withVIN vin: String) {

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/close"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen

    }

    // This is just in case DriveNow decides to remove the legacy version used in getUserData(), which returns far more information
    private func getUserDataNewVersion() {

        let url = "https://metrows.drive-now.com/php/drivenowws/v3/user"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen

    }

    private func getOpenCarToken(for cardNumber: String) {

        let url = "https://metrows.drive-now.com/php/drivenowws/v1/user/opencar"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : language,
            "device" : "HerbieNow iPhone",
            "secret" : cardNumber
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: metrowsHeaders).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON:\n\(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen
        // TODO: token als Open Car Token in Keychain speichern

    }

}
