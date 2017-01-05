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
            // swiftlint:disable:next line_length
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

enum Model {

    case mini3Door
    case mini5Door
    case miniConvertible
    case miniCountryman
    case miniClubman
    case miniPaceman
    case miniCoupe

    case bmwI3
    case bmwActiveE
    case bmw1er3Door
    case bmw1er5Door
    case bmw1erConvertible
    case bmw1erCoupe
    case bmw2erGT
    case bmw2erAT
    case bmw2erConvertible
    case bmw2erCoupe
    case bmwX1

    case smartForTwo
    case smartRoadster
    case smartForFour

    case mercedesAseries
    case mercedesBseries
    case mercedesGLA
    case mercedesCLA

    case unknown
    
    func getString() -> String {
        
        switch self {
        case .mini3Door: return "3 Door"
        case .mini5Door: return "5 Door"
        case .miniConvertible: return "Convertible"
        case .miniCountryman: return "Countryman"
        case .miniClubman: return "Clubman"
        case .miniPaceman: return "Paceman"
        case .miniCoupe: return "Coupé"
            
        case .bmwI3: return "i3"
        case .bmwActiveE: return "ActiveE"
        case .bmw1er3Door: return "1er"
        case .bmw1er5Door: return "1er"
        case .bmw1erConvertible: return "1er Convertible"
        case .bmw1erCoupe: return "1er Coupé"
        case .bmw2erGT: return "2er Grand Tourer"
        case .bmw2erAT: return "2er Active Tourer"
        case .bmw2erConvertible: return "2er Convertible"
        case .bmw2erCoupe: return "2er Coupé"
        case .bmwX1: return "X1"
            
        case .smartForTwo: return "fortwo"
        case .smartRoadster: return "roadster"
        case .smartForFour: return "forfour"
            
        case .mercedesAseries: return "A series"
        case .mercedesBseries: return "B series"
        case .mercedesGLA: return "GLA"
        case .mercedesCLA: return "CLA"
            
        case .unknown: return "Model"
        }
        
    }
    
    var doors: Int {
        
        switch self {
        case .mini3Door, .miniConvertible, .miniCoupe: return 3
        case .mini5Door, .miniCountryman, .miniClubman, .miniPaceman: return 5
            
        case .bmwI3, .bmwActiveE, .bmw1er3Door, .bmw1erConvertible, .bmw1erCoupe: return 3
        case .bmw1er5Door, .bmw2erGT, .bmw2erAT, .bmw2erConvertible, .bmw2erCoupe, .bmwX1: return 5
            
        case .smartForTwo, .smartRoadster, .smartForFour: return 3
            
        case .mercedesAseries, .mercedesBseries, .mercedesGLA, .mercedesCLA: return 5
            
        case .unknown: return 0
        }
        
    }
    
    var seats: Int {
        
        switch self {
        case .mini3Door, .miniConvertible, .miniCoupe, .mini5Door, .miniCountryman, .miniClubman, .miniPaceman: return 4
            
        case .bmwI3, .bmwActiveE: return 2
        case .bmw1er3Door, .bmw1erConvertible, .bmw1erCoupe, .bmw1er5Door, .bmw2erGT, .bmw2erAT, .bmw2erConvertible, .bmw2erCoupe, .bmwX1: return 5
            
        case .smartForTwo, .smartRoadster: return 2
        case .smartForFour: return 4
            
        case .mercedesAseries, .mercedesBseries, .mercedesGLA, .mercedesCLA: return 5
            
        case .unknown: return 0
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
