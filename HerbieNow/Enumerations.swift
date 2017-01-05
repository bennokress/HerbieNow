//
//  Enumerations.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import CoreLocation

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

    case success(_: Bool)
    case vehicles(_: [Vehicle])
    case reservation(active: Bool, reservation: Reservation?)
    case error(code: Int, codeDetail: String, message: String, parentFunction: String)

    var description: String {
        switch self {
        case .success(let success):
            return "API Call was \(success ? "successful" : "unsuccessful")."
        case .vehicles(let vehicles):
            var description = "Retrieved vehicles:\n"
            for vehicle in vehicles {
                description.append("\n\(vehicle.description)")
            }
            return description
        case .reservation(_, let optionalReservation):
            let description: String
            if let reservation = optionalReservation {
                description = reservation.description
            } else {
                description = "No reservation active."
            }
            return description
        case .error(let code, let codeDetail, let message, let parentFunction):
            return "Error \(code) in \(parentFunction): \(message) (\(codeDetail))"
        }
    }

    func getDetails() -> Bool? {
        switch self {
        case .success(let value):
            return value
        case .reservation(let hasActiveReservation, _):
            return hasActiveReservation
        default:
            return nil
        }
    }

    func getDetails() -> [Vehicle]? {
        switch self {
        case .vehicles(let list):
            return list
        default:
            return nil
        }
    }

    func getDetails() -> Reservation? {
        switch self {
        case .reservation(_, let reservation):
            return reservation
        default:
            return nil
        }
    }

}

enum Filter {
    
    case provider(driveNow: Bool, car2go: Bool)
    case make(bmw: Bool, mini:Bool, mercedes: Bool, smart: Bool)
    case model(mini3door: Bool, mini5door: Bool, miniConvertible: Bool, miniClubman: Bool, miniCountryman: Bool, bmwI3: Bool, bmw1er: Bool, bmwX1: Bool, bmw2erAT: Bool, bmw2erConvertible: Bool, smart: Bool, mercedesGLA: Bool, mercedesCLA: Bool, mercedesA: Bool, mercedesB: Bool)
    case fuelType(petrol: Bool, diesel: Bool, electric: Bool)
    case transmission(automatic: Bool, manual: Bool)
    case hp(min: Int, max: Int)
    case fuelLevel(min: Int, max: Int)
    case doors(three: Bool, five: Bool)
    case seats(two: Bool, four: Bool, five: Bool)
    case hifiSystem(only: Bool)
    
    func toString() -> String {
        switch self {
        case .provider(let driveNow, let car2go):
            return "A\(driveNow.toInt())\(car2go.toInt())"
        case .make(let bmw, let mini, let mercedes, let smart):
            return "B\(bmw.toInt())\(mini.toInt())\(mercedes.toInt())\(smart.toInt())"
        case .model(let mini3door, let mini5door, let miniConvertible, let miniClubman, let miniCountryman, let bmwI3, let bmw1er, let bmwX1, let bmw2erAT, let bmw2erConvertible, let smart, let mercedesGLA, let mercedesCLA, let mercedesA, let mercedesB):
            return "C\(mini3door.toInt())\(mini5door.toInt())\(miniConvertible.toInt())\(miniClubman.toInt())\(miniCountryman.toInt())\(bmwI3.toInt())\(bmw1er.toInt())\(bmwX1.toInt())\(bmw2erAT.toInt())\(bmw2erConvertible.toInt())\(smart.toInt())\(mercedesGLA.toInt())\(mercedesCLA.toInt())\(mercedesA.toInt())\(mercedesB.toInt())"
        case .fuelType(let petrol, let diesel, let electric):
            return "D\(petrol.toInt())\(diesel.toInt())\(electric.toInt())"
        case .transmission(let automatic, let manual):
            return "E\(automatic.toInt())\(manual.toInt())"
        case .hp(let min, let max):
            return "F\(min.to3DigitString())\(max.to3DigitString())"
        case .fuelLevel(let min, let max):
            return "G\(min.to3DigitString())\(max.to3DigitString())"
        case .doors(let three, let five):
            return "H\(three.toInt())\(five.toInt())"
        case .seats(let two, let four, let five):
            return "I\(two.toInt())\(four.toInt())\(five.toInt())"
        case .hifiSystem(let only):
            return "J\(only.toInt())"
        }
    }
    
    func vehicles(_ fullList: [Vehicle]) -> [Vehicle] {
        // TODO: switch self -> return filtered vehicles
        return fullList
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
