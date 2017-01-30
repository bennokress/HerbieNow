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
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let color: UIColor

    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, color: UIColor) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.color = color

        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}
