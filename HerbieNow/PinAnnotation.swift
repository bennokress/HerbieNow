//
//  PinAnnotation.swift
//  HerbieNow
//
//  Created by M Z on 30/01/2017.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    let title: String?
    let verhicleDescription: String
    let fuelInfo: String
    let distanceUser: String
    let coordinate: CLLocationCoordinate2D
    let color: UIColor

    init(title: String, vehicleDescription: String, fuelInfo: String, distanceUser: String, coordinate: CLLocationCoordinate2D, color: UIColor) {
        self.title = title
        self.verhicleDescription = vehicleDescription
        self.fuelInfo = fuelInfo
        self.distanceUser = distanceUser
        self.coordinate = coordinate
        self.color = color

        super.init()
    }
}
