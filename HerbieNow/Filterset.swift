//
//  Filterset.swift
//  HerbieNow
//
//  Created by Benno Kress on 05.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

struct Filterset {
    
    // MARK: Stored Properties

    var filters: [Filter] = []
    var position: Int = 0
    var name: String = "defaultName"
    var encodedImage: String = ""
    
    // MARK: Computed Properties

    var asString: String {
        var stringArray: [String] = []
        for filter in filters {
            stringArray.append(filter.toString())
        }
        stringArray.append(String(position))
        stringArray.append(name)
        stringArray.append(encodedImage)
        return stringArray.joined(separator: ":")
    }
    
    var providerFilter: Filter { return filters[0] }
    var makeFilter: Filter { return filters[1] }
    var modelFilter: Filter { return filters[2] }
    var fuelTypeFilter: Filter { return filters[3] }
    var transmissionFilter: Filter { return filters[4] }
    var hpFilter: Filter { return filters[5] }
    var fuelLevelFilter: Filter { return filters[6] }
    var doorsFilter: Filter { return filters[7] }
    var seatsFilter: Filter { return filters[8] }
    var hiFiSystemFilter: Filter { return filters[9] }
    
    // MARK: Initialization

    init(from initString: String = "11:1111:11111111111111111:111:11:070200:000100:11:111:0:0:Default Set:no image") {
        let stringArray = initString.splitted(by: ":")
        
        guard stringArray.count == 13 else {
            Debug.print(.error(source: .location(Source()), message: "Not enough parts in Filterset Initializer String!"))
            return
        }

        let providerBoolArray = stringArray[0].toBoolArray()
        let providerFilter: Filter = getProviderFilter(from: providerBoolArray)
        filters.append(providerFilter)

        let makeBoolArray = stringArray[1].toBoolArray()
        let makeFilter: Filter = getMakeFilter(from: makeBoolArray)
        filters.append(makeFilter)

        let modelBoolArray = stringArray[2].toBoolArray()
        let modelFilter: Filter = getModelFilter(from: modelBoolArray)
        filters.append(modelFilter)

        let fuelTypeBoolArray = stringArray[3].toBoolArray()
        let fuelTypeFilter: Filter = getFuelTypeFilter(from: fuelTypeBoolArray)
        filters.append(fuelTypeFilter)

        let transmissionBoolArray = stringArray[4].toBoolArray()
        let transmissionFilter: Filter = getTransmissionFilter(from: transmissionBoolArray)
        filters.append(transmissionFilter)

        let hpIntArray = stringArray[5].toIntArray()
        let hpFilter: Filter = getHPFilter(from: hpIntArray)
        filters.append(hpFilter)

        let fuelLevelIntArray = stringArray[6].toIntArray()
        let fuelLevelFilter: Filter = getFuelLevelFilter(from: fuelLevelIntArray)
        filters.append(fuelLevelFilter)

        let doorsBoolArray = stringArray[7].toBoolArray()
        let doorsFilter: Filter = getDoorsFilter(from: doorsBoolArray)
        filters.append(doorsFilter)

        let seatsArray = stringArray[8].toBoolArray()
        let seatsFilter: Filter = getSeatsFilter(from: seatsArray)
        filters.append(seatsFilter)

        let hiFiSystemArray = stringArray[9].toBoolArray()
        let hiFiSystemFilter: Filter = getHiFiSystemFilter(from: hiFiSystemArray)
        filters.append(hiFiSystemFilter)

        position = stringArray[10].integer

        name = stringArray[11]

        encodedImage = stringArray[12]
    }

    // MARK: Public Functions

    func filter(vehicles: [Vehicle]) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = vehicles

        for filter in filters {
            switch filter {
            case .provider:
                filteredVehicles = filterByProvider(filteredVehicles, with: filter)
            case .make:
                filteredVehicles = filterByMake(filteredVehicles, with: filter)
            case .model:
                filteredVehicles = filterByModel(filteredVehicles, with: filter)
            case .fuelType:
                filteredVehicles = filterByFueltype(filteredVehicles, with: filter)
            case .transmission:
                filteredVehicles = filterByTransmission(filteredVehicles, with: filter)
            case .hp:
                filteredVehicles = filterByHP(filteredVehicles, with: filter)
            case .fuelLevel:
                filteredVehicles = filterByFuellevel(filteredVehicles, with: filter)
            case .doors:
                filteredVehicles = filterByDoors(filteredVehicles, with: filter)
            case .seats:
                filteredVehicles = filterBySeats(filteredVehicles, with: filter)
            case .hifiSystem:
                filteredVehicles = filterByHiFiSystem(filteredVehicles, with: filter)
            }
        }

        return filteredVehicles

    }
    
    // MARK: Mutating Functions

    mutating func update(filter newFilter: Filter) {
        for (index, filter) in filters.enumerated() {
            if filter == newFilter {
                filters[index] = newFilter
            }
        }
    }

    mutating func update(name newName: String) {
        name = newName
    }

    mutating func update(position newPosition: Int) {
        position = newPosition
    }

    mutating func update(image newEncodedImage: String) {
        encodedImage = newEncodedImage
    }
    
    // MARK: Console Output
    
    func debugPrint() {
        Debug.print(.info(source: .location(Source()), message: "Received Filterset named \"\(name)\":"))
        if case .model(let mini3door, let mini5door, let miniConvertible, let miniClubman, _, let bmwI3, let bmw1er, let bmwX1, let bmw2erAT, let bmw2erConvertible, let smartForTwo, _, _, let mercedesGLA, let mercedesCLA, let mercedesA, let mercedesB) = self.modelFilter {
            Debug.print(.list(item: "Models", indent: 1))
            if mini3door { Debug.print(.list(item: "Mini 3 Door", indent: 2)) }
            if mini5door { Debug.print(.list(item: "Mini 5 Door", indent: 2)) }
            if miniConvertible { Debug.print(.list(item: "Mini Convertible", indent: 2)) }
            if miniClubman { Debug.print(.list(item: "Mini Clubman", indent: 2)) }
            if bmwI3 { Debug.print(.list(item: "BMW i3", indent: 2)) }
            if bmw1er { Debug.print(.list(item: "BMW 1er", indent: 2)) }
            if bmwX1 { Debug.print(.list(item: "BMW X1", indent: 2)) }
            if bmw2erAT { Debug.print(.list(item: "BMW 2er Active Tourer", indent: 2)) }
            if bmw2erConvertible { Debug.print(.list(item: "BMW 2er Convertible", indent: 2)) }
            if smartForTwo { Debug.print(.list(item: "Smart fortwo", indent: 2)) }
            if mercedesA { Debug.print(.list(item: "Mercedes Benz A Class", indent: 2)) }
            if mercedesB { Debug.print(.list(item: "Mercedes Benz B Class", indent: 2)) }
            if mercedesCLA { Debug.print(.list(item: "Mercedes Benz CLA", indent: 2)) }
            if mercedesGLA { Debug.print(.list(item: "Mercedes Benz GLA", indent: 2)) }
        }
        if case .fuelType(let petrol, let diesel, let electric) = self.fuelTypeFilter {
            Debug.print(.list(item: "Fuel Types", indent: 1))
            if petrol { Debug.print(.list(item: "Petrol", indent: 2)) }
            if diesel { Debug.print(.list(item: "Diesel", indent: 2)) }
            if electric { Debug.print(.list(item: "Electric", indent: 2)) }
        }
        if case .transmission(let automatic, let manual) = self.transmissionFilter {
            Debug.print(.list(item: "Transmission Types", indent: 1))
            if automatic { Debug.print(.list(item: "Automatic", indent: 2)) }
            if manual { Debug.print(.list(item: "Manual", indent: 2)) }
        }
        if case .hp(let min, let max) = self.hpFilter {
            Debug.print(.list(item: "Horse Power", indent: 1))
            Debug.print(.list(item: "Min: \(min)", indent: 2))
            Debug.print(.list(item: "Max: \(max)", indent: 2))
        }
        if case .fuelLevel(let min, let max) = self.fuelLevelFilter {
            Debug.print(.list(item: "Fuel Level", indent: 1))
            Debug.print(.list(item: "Min: \(min)", indent: 2))
            Debug.print(.list(item: "Max: \(max)", indent: 2))
        }
        if case .doors(let three, let five) = self.doorsFilter {
            Debug.print(.list(item: "Doors", indent: 1))
            if three { Debug.print(.list(item: "Three", indent: 2)) }
            if five { Debug.print(.list(item: "Five", indent: 2)) }
        }
        if case .seats(let two, let four, let five) = self.seatsFilter {
            Debug.print(.list(item: "Seats", indent: 1))
            if two { Debug.print(.list(item: "Two", indent: 2)) }
            if four { Debug.print(.list(item: "Four", indent: 2)) }
            if five { Debug.print(.list(item: "Five", indent: 2)) }
        }
        if case .hifiSystem(let only) = self.hiFiSystemFilter {
            Debug.print(.list(item: "Only Cars with upgraded HiFi System", indent: 1))
            if only { Debug.print(.list(item: "yes", indent: 2)) } else { Debug.print(.list(item: "no", indent: 2)) }
        }
    
    }

}

// MARK: - Internal Functions
extension Filterset: InternalRouting {
    
    // MARK: Private Getter

    fileprivate func getProviderFilter(from boolArray: [Bool]) -> Filter {
        return .provider(driveNow: boolArray[0], car2go: boolArray[1])
    }

    fileprivate func getMakeFilter(from boolArray: [Bool]) -> Filter {
        return .make(bmw: boolArray[0], mini: boolArray[1], mercedes: boolArray[2], smart: boolArray[3])
    }

    fileprivate func getModelFilter(from boolArray: [Bool]) -> Filter {
        return .model(mini3door: boolArray[0], mini5door: boolArray[1], miniConvertible: boolArray[2], miniClubman: boolArray[3], miniCountryman: boolArray[4], bmwI3: boolArray[5], bmw1er: boolArray[6], bmwX1: boolArray[7], bmw2erAT: boolArray[8], bmw2erConvertible: boolArray[9], smartForTwo: boolArray[10], smartRoadster: boolArray[11], smartForFour: boolArray[12], mercedesGLA: boolArray[13], mercedesCLA: boolArray[14], mercedesA: boolArray[15], mercedesB: boolArray[16])
    }

    fileprivate func getFuelTypeFilter(from boolArray: [Bool]) -> Filter {
        return .fuelType(petrol: boolArray[0], diesel: boolArray[1], electric: boolArray[2])
    }

    fileprivate func getTransmissionFilter(from boolArray: [Bool]) -> Filter {
        return .transmission(automatic: boolArray[0], manual: boolArray[1])
    }

    fileprivate func getHPFilter(from intArray: [Int]) -> Filter {
        return .hp(min: intArray[0], max: intArray[1])
    }

    fileprivate func getFuelLevelFilter(from intArray: [Int]) -> Filter {
        return .fuelLevel(min: intArray[0], max: intArray[1])
    }

    fileprivate func getDoorsFilter(from boolArray: [Bool]) -> Filter {
        return .doors(three: boolArray[0], five: boolArray[1])
    }

    fileprivate func getSeatsFilter(from boolArray: [Bool]) -> Filter {
        return .seats(two: boolArray[0], four: boolArray[1], five: boolArray[2])
    }

    fileprivate func getHiFiSystemFilter(from boolArray: [Bool]) -> Filter {
        return .hifiSystem(only: boolArray[0])
    }

    // MARK: Filer by ...

    fileprivate func filterByProvider(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .provider(driveNowFilterActivated, car2goFilterActivated) = filter {
            for vehicle in fullList {
                switch vehicle.provider {
                case .driveNow:
                    if driveNowFilterActivated { filteredVehicles.append(vehicle) }
                case .car2go:
                    if car2goFilterActivated { filteredVehicles.append(vehicle) }
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByMake(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .make(bmwFilterActivated, miniFilterActivated, mercedesFilterActivated, smartFilterActivated) = filter {
            for vehicle in fullList {
                switch vehicle.make {
                case .bmw:
                    if bmwFilterActivated { filteredVehicles.append(vehicle) }
                case .mini:
                    if miniFilterActivated { filteredVehicles.append(vehicle) }
                case .mercedes:
                    if mercedesFilterActivated { filteredVehicles.append(vehicle) }
                case .smart:
                    if smartFilterActivated { filteredVehicles.append(vehicle) }
                default:
                    break
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByModel(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .model(mini3doorFilterActivated, mini5doorFilterActivated, miniConvertibleFilterActivated, miniClubmanFilterActivated, miniCountrymanFilterActivated, bmwI3FilterActivated, bmw1erFilterActivated, bmwX1FilterActivated, bmw2erATFilterActivated, bmw2erConvertibleFilterActivated, smartForTwoFilterActivated, smartRoadsterFilterActivated, smartForFourFilterActivated, mercedesGLAFilterActivated, mercedesCLAFilterActivated, mercedesAFilterActivated, mercedesBFilterActivated) = filter {
            for vehicle in fullList {
                switch vehicle.model {
                case .mini3Door:
                    if mini3doorFilterActivated { filteredVehicles.append(vehicle) }
                case .mini5Door:
                    if mini5doorFilterActivated { filteredVehicles.append(vehicle) }
                case .miniConvertible:
                    if miniConvertibleFilterActivated { filteredVehicles.append(vehicle) }
                case .miniClubman:
                    if miniClubmanFilterActivated { filteredVehicles.append(vehicle) }
                case .miniCountryman:
                    if miniCountrymanFilterActivated { filteredVehicles.append(vehicle) }
                case .bmwI3:
                    if bmwI3FilterActivated { filteredVehicles.append(vehicle) }
                case .bmw1er3Door:
                    if bmw1erFilterActivated { filteredVehicles.append(vehicle) }
                case .bmw1er5Door:
                    if bmw1erFilterActivated { filteredVehicles.append(vehicle) }
                case .bmwX1:
                    if bmwX1FilterActivated { filteredVehicles.append(vehicle) }
                case .bmw2erAT:
                    if bmw2erATFilterActivated { filteredVehicles.append(vehicle) }
                case .bmw2erConvertible:
                    if bmw2erConvertibleFilterActivated { filteredVehicles.append(vehicle) }
                case .smartForTwo:
                    if smartForTwoFilterActivated { filteredVehicles.append(vehicle) }
                case .smartRoadster:
                    if smartRoadsterFilterActivated { filteredVehicles.append(vehicle) }
                case .smartForFour:
                    if smartForFourFilterActivated { filteredVehicles.append(vehicle) }
                case .mercedesGLA:
                    if mercedesGLAFilterActivated { filteredVehicles.append(vehicle) }
                case .mercedesCLA:
                    if mercedesCLAFilterActivated { filteredVehicles.append(vehicle) }
                case .mercedesAclass:
                    if mercedesAFilterActivated { filteredVehicles.append(vehicle) }
                case .mercedesBclass:
                    if mercedesBFilterActivated { filteredVehicles.append(vehicle) }
                default:
                    break
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByFueltype(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .fuelType(petrolFilterActivated, dieselFilterActivated, electricFilterActivated) = filter {
            for vehicle in fullList {
                switch vehicle.fuelType {
                case .petrol:
                    if petrolFilterActivated { filteredVehicles.append(vehicle) }
                case .diesel:
                    if dieselFilterActivated { filteredVehicles.append(vehicle) }
                case .electric:
                    if electricFilterActivated { filteredVehicles.append(vehicle) }
                default:
                    break
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByTransmission(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .transmission(automaticFilterActivated, manualFilterActivated) = filter {
            for vehicle in fullList {
                switch vehicle.transmissionType {
                case .automatic:
                    if automaticFilterActivated { filteredVehicles.append(vehicle) }
                case .manual:
                    if manualFilterActivated { filteredVehicles.append(vehicle) }
                default:
                    break
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByHP(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .hp(minHP, maxHP) = filter {
            for vehicle in fullList {
                if vehicle.hp >= minHP && vehicle.hp <= maxHP {
                    filteredVehicles.append(vehicle)
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByFuellevel(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .fuelLevel(minFuelLevel, maxFuelLevel) = filter {
            for vehicle in fullList {
                if vehicle.fuelLevel >= minFuelLevel && vehicle.fuelLevel <= maxFuelLevel {
                    filteredVehicles.append(vehicle)
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByDoors(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .doors(threeFilterActivated, fiveFilterActivated) = filter {
            for vehicle in fullList {
                switch vehicle.doors {
                case 3:
                    if threeFilterActivated { filteredVehicles.append(vehicle) }
                case 5:
                    if fiveFilterActivated { filteredVehicles.append(vehicle) }
                default:
                    break
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterBySeats(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .seats(twoFilterActivated, fourFilterActivated, fiveFilterActivated) = filter {
            for vehicle in fullList {
                switch vehicle.seats {
                case 2:
                    if twoFilterActivated { filteredVehicles.append(vehicle) }
                case 4:
                    if fourFilterActivated { filteredVehicles.append(vehicle) }
                case 5:
                    if fiveFilterActivated { filteredVehicles.append(vehicle) }
                default:
                    break
                }
            }
        }

        return filteredVehicles
    }

    fileprivate func filterByHiFiSystem(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        if case let .hifiSystem(onlyFilterActivated) = filter {
            for vehicle in fullList {
                // Type HiFiSystem ist noch nicht als Enum erstellt, aber ein einfacher bool reicht ja hier aus
                if vehicle.hasHiFiSystem || (!vehicle.hasHiFiSystem && !onlyFilterActivated) {
                    filteredVehicles.append(vehicle)
                }
            }
        }

        return filteredVehicles
    }

}

// MARK: - Equatable Conformance
extension Filterset: Equatable {
    
    static func == (lhs: Filterset, rhs: Filterset) -> Bool {
        return lhs.asString == rhs.asString
    }
    
}
