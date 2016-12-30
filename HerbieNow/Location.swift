//
//  Location.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

struct Location {

    let street: String
    let areaCode: String
    let city: String
    let latitude: Double
    let longitude: Double

    let coordinateDescription: String

    init(latitude: Double, longitude: Double) {

        self.latitude = latitude
        self.longitude = longitude

        coordinateDescription = "lat: \(latitude), long: \(longitude)"

        func getStreet(from lat: Double, _ long: Double) -> String {
            // TODO: reverse Geocode
            return ""
        }

        func getAreaCode(from lat: Double, _ long: Double) -> String {
            // TODO: reverse Geocode
            return ""
        }

        func getCity(from lat: Double, _ long: Double) -> String {
            // TODO: reverse Geocode
            return ""
        }

        self.street = getStreet(from: latitude, longitude)
        self.areaCode = getAreaCode(from: latitude, longitude)
        self.city = getCity(from: latitude, longitude)

    }
}
