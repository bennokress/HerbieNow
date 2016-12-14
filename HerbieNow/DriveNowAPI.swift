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

    // Singleton - call via DriveNowAPI.shared
    static var shared = DriveNowAPI()
    private init() {}

    let headers: HTTPHeaders = [
        "host": "metrows.drive-now.com",
        "accept": "application/json;v=1.9",
        "accept-language": "de",
        "x-api-key": "adf51226795afbc4e7575ccc124face7",
        "accept-encoding": "json, deflate",
        "content-type": "application/x-www-form-urlencoded",
        "apikey": "hfh1ukf765iutqed4mvilmbzfexdywak",
        "connection": "keep-alive"
    ]

    let apiKey = "hfh1ukf765iutqed4mvilmbzfexdywak"
    let language = "en"

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

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            } else {
                print("Error: No JSON received!")
            }
        }

        // TODO: JSON parsen
        // TODO: auth als X-Auth-Token in Keychain speichern

    }

    func getUserData() {

        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/legacy/user?language=de&auth=\(xAuthToken)"

        Alamofire.request(url).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

        // TODO: JSON parsen
        // TODO: Open Car Token in Keychain speichern

    }

    func getReservationStatus() {

        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/user/status?language=de&auth=\(xAuthToken)"

        Alamofire.request(url).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

        // TODO: JSON parsen

    }

    func getAvailableVehicles() {

        let url = "https://api2.drive-now.com/cities/4604/cars?expand=full"

        Alamofire.request(url, headers: headers).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }

    func reserveVehicle(withVIN vin: String) {

        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let openCarToken = "YYY"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/reservation/request?auth=\(xAuthToken)&language=de"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "carID" : vin,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }

    func cancelReservation() {

        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let openCarToken = "YYY"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/reservation/cancel?auth=\(xAuthToken)&language=de"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }

    func openVehicle(withVIN vin: String) {

        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let openCarToken = "YYY"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/open?auth=\(xAuthToken)&language=de"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }

    func closeVehicle(withVIN vin: String) {

        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let openCarToken = "YYY"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/close?auth=\(xAuthToken)&language=de"

        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }

}
