//
//  Filteroption.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import CoreLocation

enum Filterset {

    // MARK: - Providers
    case driveNow
    case car2go

    // MARK: - Characteristics
    case sportscar
    case hifiUpgrade
    case convertible
    case electric
    // TODO: Implement more filteroptions

}

enum Provider {

    case driveNow
    case car2go

}

enum APIRequestMethod {
    
    case get
    case post
    case delete
    
}

enum APIRequest {
    
    case login(username: String, password: String)
    case userData
    case carList
    case reservationStatus
    case reserveCar(withVIN: String)
    case cancelReservation
    case openCar
    case closeCar
    
}
