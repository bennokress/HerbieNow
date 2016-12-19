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

enum APIRequestMethod: String {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"

    func method() -> String {
        return self.rawValue
    }

}

enum APICallResult {

    // TODO: handle response type better
    case success(contents: Any?)
    case error(code: Int, codeDetail: String, message: String, parentFunction: String)

    var description: String {
        switch self {
        case .success:
            return "API Call was successful."
        case .error(let code, let codeDetail, let message, let parentFunction):
            return "Error \(code) in \(parentFunction): \(message) (\(codeDetail))"
        }
    }

}

enum FuelType: Character {

    case petrol = "P"
    case diesel = "D"
    case electric = "E"
    case unknown = "U"

    init(fromRawValue rawValue: Character) {
        self = FuelType(rawValue: rawValue) ?? .unknown
    }

    func description() -> String {
        switch self {
        case .petrol:
            return "Petrol"
        case .diesel:
            return "Diesel"
        case .electric:
            return "Electric"
        default:
            return "Unknown fuel type"
        }
    }

}

enum Make: String {

    case bmw = "BMW"
    case mercedes = "Mercedes-Benz"
    case mini = "MINI"
    case smart = "smart"
    case unknown = "Unknown"

    init(fromVIN vin: String) {

        switch vin.makeID {
        case "WBA", "WBS", "WBY":
            self = .bmw
        case "WDB", "WDC", "WDD":
            self = .mercedes
        case "WME":
            self = .smart
        case "WMW":
            self = .mini
        default:
            self = .unknown
        }

    }

}

enum Provider: String {

    // String representation is used for prefixing UserDefaults and Keychain keys

    case driveNow = "DriveNow"
    case car2go = "Car2Go"

    func api() -> API {

        switch self {
        case .driveNow:
            return DriveNowAPI.shared
        case .car2go:
            return Car2GoAPI.shared
        }

    }

}

enum TransmissionType: Character {

    case automatic = "A"
    case manual = "M"
    case unknown = "U"

    init(fromRawValue rawValue: Character) {
        self = TransmissionType(rawValue: rawValue) ?? .unknown
    }

    func description() -> String {
        switch self {
        case .automatic:
            return "Automatic"
        case .manual:
            return "Manual"
        default:
            return "Unknown fuel type"
        }
    }

}
