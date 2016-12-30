//
//  Location.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import CoreLocation

class Location {

    typealias AddressDictFormat = [String: Any]

    let latitude: Double
    let longitude: Double
    
    var city: String = ""
    var street: String = ""
    var areaCode: String = ""

    let coordinateDescription: String

    // Computed properties for location
    var currentLocationAsObject: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    init(latitude: Double, longitude: Double) {

        self.latitude = latitude
        self.longitude = longitude

        //        coordinateDescription = "lat: \(latitude), long: \(longitude)"
        coordinateDescription = street + ", " + areaCode + ", " + city

        //        self.street = getStreet(from: latitude, longitude)
        //        self.areaCode = getAreaCode(from: latitude, longitude)
        //        self.city = getCity(from: latitude, longitude)

        getAdress { result in

            guard let city = result?.city, let street = result?.street, let areaCode = result?.areaCode else {
                return
            }
            self.city = city
            self.street = street
            self.areaCode = areaCode

        }
    }

    func getAdress(completion: @escaping ((street:String, areaCode:String, city:String)?) -> Void) {
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
                
                guard let city = dict["City"] as? String, let street = dict["Street"] as? String, let areaCode = dict["ZIP"] as? String else {
                    return
                }
                
                self.city = city
                self.areaCode = areaCode
                self.street = street
                completion((street, areaCode, city))
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
