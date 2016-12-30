//
//  Location.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {

    typealias AddressDictFormat = [String: Any]

    let latitude: Double
    let longitude: Double

    let coordinateDescription: String

    // Computed properties for location
    var currentLocationAsObject: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    init(latitude: Double, longitude: Double) {

        self.latitude = latitude
        self.longitude = longitude

        //        coordinateDescription = "lat: \(latitude), long: \(longitude)"
        coordinateDescription = ""

        //        self.street = getStreet(from: latitude, longitude)
        //        self.areaCode = getAreaCode(from: latitude, longitude)
        //        self.city = getCity(from: latitude, longitude)

        getAdress { result in

            guard let city = result?["City"] as? String, let street = result?["Street"] as? String, let areaCode = result?["ZIP"] as? String else {
                return
            }

            print(street + ", " + areaCode + ", " + city)

        }
    }

    func getAdress(completion: @escaping (AddressDictFormat?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocationAsObject) { (placemarks, error) in
            if error != nil {
                print("error")
                completion(nil)
            } else {
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                guard let dict = placeMark.addressDictionary as? (AddressDictFormat) else {
                    return
                }
                completion(dict)
            }

        }
    }

    func getStreet(from lat: Double, _ long: Double) -> String {
        // TODO: reverse Geocode
        return ""
    }

    func getAreaCode(from lat: Double, _ long: Double) -> String {
        // TODO: reverse Geocode
        return ""
    }

}
