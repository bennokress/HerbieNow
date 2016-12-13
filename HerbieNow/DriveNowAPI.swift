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

    var api: SessionManager

    // Singleton - call via DriveNowAPI.shared
    static var shared = DriveNowAPI()
    private init() {

        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers.removeAll()

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers

        api = Alamofire.SessionManager(configuration: configuration)

    }

    let loginHeaders: HTTPHeaders = [
        "Accept" : "application/json;v=1.6",
        "Accept-Encoding" : "gzip, deflate, sdch",
        "Accept-Language" : "de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4",
        "Connection" : "keep-alive",
        "Host" : "api2.drive-now.com",
        "Origin" : "https://de.drive-now.com",
        "X-Api-Key" : "adf51226795afbc4e7575ccc124face7",
        "X-Language" : "de",
        "Content-Type" : "application/json"
    ]

    var fullHeaders: HTTPHeaders {
        var headers = loginHeaders
        // TODO: X-Auth-Token aus Keychain laden
        headers["X-Auth-Token"] = "XXX"
        return headers
    }

}

extension DriveNowAPI: API {

    func login(as username: String, withPassword password: String) {

        let url = "https://api2.drive-now.com/login"

        let parameters: Parameters = [
            "username" : username,
            "password" : password
        ]

        let postage = api.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: loginHeaders).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

        debugPrint(postage)

        // TODO: JSON parsen
        // TODO: X-Auth-Token in Keychain speichern

    }

    func getUserData() {
        
        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/legacy/user?language=de&auth=\(xAuthToken)"

        api.request(url).responseJSON { response in
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

        api.request(url).responseJSON { response in
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

        api.request(url, method: .get, encoding: JSONEncoding.default, headers: fullHeaders).responseJSON { response in
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
        
        api.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: fullHeaders).responseJSON { response in
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
        
        api.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: fullHeaders).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }

    func openVehicle(withVin vin: String) {
        
        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let openCarToken = "YYY"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/open?auth=\(xAuthToken)&language=de"
        
        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]
        
        api.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: fullHeaders).responseJSON { response in
            print("Request: \(response.request)")    // original URL request
            print("Response: \(response.response)")  // HTTP URL response
            print("Data: \(response.data)")          // server data
            print("Result: \(response.result)")      // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }

    func closeVehicle(withVin vin: String) {
        
        // TODO: X-Auth-Token aus Keychain laden
        let xAuthToken = "XXX"
        let openCarToken = "YYY"
        let url = "https://metrows.drive-now.com/php/drivenowws/v1/cars/\(vin)/close?auth=\(xAuthToken)&language=de"
        
        let parameters: Parameters = [
            "auth" : xAuthToken,
            "language" : "de",
            "openCarToken" : openCarToken
        ]
        
        api.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: fullHeaders).responseJSON { response in
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
