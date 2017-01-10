//
//  Car2GoAPI.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import UIKit
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
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

    func login(in viewController: UIViewController?, completion: @escaping Callback) {

        guard let view = viewController else {
            let error = APICallResult.error(code: 0, codeDetail: "no_viewController", message: "No valid view controller passed with login call for Car2Go!", parentFunction: #function)
            completion(error)
            return
        }

        var oauthswift: OAuth1Swift

        oauthswift = OAuth1Swift(
            consumerKey:    consumerKey,
            consumerSecret: consumerKeySecret,
            requestTokenUrl: "https://www.car2go.com/api/reqtoken",
            authorizeUrl:    "https://www.car2go.com/api/authorize",
            accessTokenUrl:  "https://www.car2go.com/api/accesstoken"
        )

        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: view, oauthSwift: oauthswift)

        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/car2go")!,
            success: { credential, response, parameters in
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                print(parameters["user_id"])
        },
            failure: { error in
                print(error.localizedDescription)
        }
        )

        /*
         let functionName = name(of: self)+"."+#function
         guard let _ = appData.getUsername(for: car2go), let _ = appData.getPassword(for: car2go) else {
         let error = APICallResult.error(code: 0, codeDetail: "missing_key", message: "The Car2Go Username and / or the password are missing in Keychain!", parentFunction: functionName)
         completion(error)
         return
         }


         var oauth_token: String
         var oauth_token_secret: String
         var oauth_consumer_key: String
         var verifier: String
         var oauth_signature: String
         let step1Header: HTTPHeaders
         step1Header = apiHeader
         .appending("https://www.car2go.com/api/reqtoken", forKey: "realm")
         .appending(consumerKey, forKey: "oauth_consumer_key")
         .appending(oauth_signature_method, forKey: "oauth_signature_method")
         .appending( String(NSDate().timeIntervalSince1970), forKey: "oauth_timestamp")
         .appending(oauth_version, forKey: "version")
         .appending("", forKey: "oauth_signature")
         .appending("oob", forKey: "oauth_callback")

         https://www.car2go.com/api/reqtoken
         ?oauth_consumer_key=HerbyNow
         &oauth_signature_method=HMAC-SHA1
         &oauth_timestamp=1484055579
         &oauth_nonce=DLKOSa
         &oauth_version=1.0
         &oauth_signature=PjFZgPu6/oMCBLhdOv8nARXSiBs=
         &oauth_callback=oob
         Known:

         consumer_key            :       HerbyNow
         consumer_key_secret     :       e1t9zimQmxmGrJ9eoMaq
         signature_method        :       HMAC-SHA1
         timestamp               :       actualTime
         oauth_nonce             :
         oauth_signature         :       ändert sich bei jedem Request

         To Store:

         oauth_token
         oauth_secret
         oauth_consumer_key
         oauth_verifier
         oauth_signature

         */

        //Step 1 Request Token      url: https://www.car2go.com/api/reqtoken
        /*



         Request containts:
         - oauth_consumer_key
         - oauth_signature_method
         - oauth_signature
         - oauth_timestamp
         - oauth_nonce
         - oauth_version
         - oauth_callback

         Answer:
         - oauth_token
         - oauth_token_secret
         - oauth_callback_confirmed
         */

        //Step 2                url: https://www.car2go.com/api/authorize
        /*


         Request needs optional
         - oauth_token

         Service Provider Directs User to Consumer
         - oauth_token
         - oauth_verifier

         */

        //Step 3 Access Token           url: https://www.car2go.com/api/accesstoken

        /*



         Service Provider Grants Access Token
         - oauth_token
         - oauth_token_secret

         - oauth_consumer_key
         - oauth_token
         - oauth_signature_method
         - oauth_signature
         - oauth_timestamp
         - oauth_nonce
         - oauth_version


         */

    }

    func getUserData(completion: @escaping Callback) {

    }

    func getReservationStatus(completion: @escaping Callback) {

    }

    func getAvailableVehicles(around location: Location, completion: @escaping Callback) {

        let functionName = funcID(class: self, func:#function)

        getNearestCity(actualLocation: location) { cityString in

            let url = "https://www.car2go.com/api/v2.1/vehicles?loc=\(cityString.replaceGermanCharacters())&oauth_consumer_key=\(self.consumerKey)&format=\(self.format)"

            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: self.apiHeader).responseJASON { callback in

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

    }

    func getNearestCity (actualLocation location: Location, completion: @escaping (_ city: String) -> Void) {

        let url = "https://www.car2go.com/api/v2.1/locations?oauth_consumer_key=\(consumerKey)&format=\(format)"

        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: apiHeader).responseJASON { callback in

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
