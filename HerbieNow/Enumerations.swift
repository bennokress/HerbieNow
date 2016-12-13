//
//  Enumerations.swift
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

    func api() -> API {

        switch self {
        case .driveNow:
            return DriveNowAPI.shared
        case .car2go:
            return Car2GoAPI.shared
        }

    }

}

enum APIRequestMethod: String {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"

}
