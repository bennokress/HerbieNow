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

        coordinateDescription = "lat: \(latitude), long: \(longitude)"
    }

    func getAddress(completion: @escaping ((street: String, areaCode: String, city: String)?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocationAsObject) { (placemarks, error) in
            if error != nil {
                print(Debug.error(class: self, func: #function, message: "Reverse Geocoding failed"))
                completion(nil)
            } else {
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]

                guard let dict = placeMark.addressDictionary as? (AddressDictFormat) else {
                    return
                }

                guard let city = dict["City"] as? String, let street = dict["Street"] as? String, let areaCode = dict["ZIP"] as? String else {
                    return
                }

                print(Debug.success(class: self, func: #function, message: "Reverse Geocoding: (\(self.latitude), \(self.longitude)) is \(street) in \(areaCode) \(city)"))
                completion((street, areaCode, city))
            }

        }
    }

}
