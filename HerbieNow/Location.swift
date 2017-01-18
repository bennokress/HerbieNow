//
//  Location.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {

    typealias AddressDictFormat = [String: Any]

    let latitude: Double
    let longitude: Double

    let car2goCityName: String?

    let coordinateDescription: String

    // Computed properties for location
    var asObject: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    init(latitude: Double, longitude: Double, car2goCityName: String? = nil) {

        self.latitude = latitude
        self.longitude = longitude
        self.car2goCityName = car2goCityName

        coordinateDescription = "lat: \(latitude), long: \(longitude)"
    }

    func getAddress(completion: @escaping ((street: String, areaCode: String, city: String)?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self.asObject) { (placemarks, error) in
            if error != nil {
                print(Debug.error(source: (name(of: self), #function), message: "Reverse Geocoding failed"))
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

                print(Debug.success(source: (name(of: self), #function), message: "Reverse Geocoding: (\(self.latitude), \(self.longitude)) is \(street) in \(areaCode) \(city)"))
                completion((street, areaCode, city))
            }

        }
    }

    func getDistance(from otherLocation:CLLocation) -> Double {
        return otherLocation.distance(from: self.asObject)
    }
}
