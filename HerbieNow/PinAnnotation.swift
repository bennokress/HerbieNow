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
    let pin: UIImage
    let vehicleObject: Vehicle

    init(vehicle: Vehicle) {
        self.title = "Car"
        self.verhicleDescription = vehicle.detailsForLine1
        self.fuelInfo = vehicle.detailsForLine2
        self.distanceUser = vehicle.detailsForLine3
        self.coordinate = vehicle.location.asObject.coordinate
        vehicle.provider == .driveNow ? (self.color = UIColor.blue) : (self.color = UIColor.red)
        self.image = UIImage.from(base64string: vehicle.encodedImage)
        self.vin = vehicle.vin
        self.vehicleObject = vehicle
        self.pin = (vehicle.provider == .driveNow) ? #imageLiteral(resourceName: "pinDriveNow") : #imageLiteral(resourceName: "pinCar2Go")

        super.init()
    }
}
