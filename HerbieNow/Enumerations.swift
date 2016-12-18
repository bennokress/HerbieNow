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
