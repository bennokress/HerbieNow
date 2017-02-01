//
//  PinAnnotation.swift
//  HerbieNow
//
//  Created by M Z on 30/01/2017.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    let title: String?
    let verhicleDescription: String
    let fuelInfo: String
    let distanceUser: String
    let coordinate: CLLocationCoordinate2D
    let color: UIColor
    let image: UIImage
    let vin: String

    init(vehicle: Vehicle, userDistance: String) {
        self.title = "Car"
        self.verhicleDescription = vehicle.detailsForLine1
        self.fuelInfo = vehicle.detailsForLine2
        self.distanceUser = userDistance
        self.coordinate = vehicle.location.asObject.coordinate
        vehicle.provider == .driveNow ? (self.color = UIColor.blue) : (self.color = UIColor.red)
        self.image = UIImage.from(base64string: vehicle.encodedImage)
        self.vin = vehicle.vin

        super.init()
    }
}
