//
//  Filterset.swift
//  HerbieNow
//
//  Created by Benno Kress on 05.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

struct Filterset {

    private var filters: [Filter] = []
    private var position: Int = 0
    private var name: String = "defaultName"
    private var image = UIImage()

    var asString: String {
        var imageString = "invalid image"
        if let imageData: Data = UIImagePNGRepresentation(image) {
            imageString = imageData.base64EncodedString(options: .lineLength64Characters)
        }
        var stringArray: [String] = []
        for filter in filters {
            stringArray.append(filter.toString())
        }
        stringArray.append(String(position))
        stringArray.append(name)
        stringArray.append(imageString)
        return stringArray.joined(separator: ":")
    }

    init(from initString: String) {
        // String has the form: 00:0000:00000000000000000:000:00:000000:000000:00:000:0:0:name:imagecoded
        let stringArray = initString.splited(by: ":")

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

        if let imageData = Data(base64Encoded: stringArray[12], options: Data.Base64DecodingOptions(rawValue: 0)), let image = UIImage(data: imageData) {
            self.image = image
        }
    }

    // MARK: - Public Functions

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

    func getName() -> String {
        return name
    }

    func getPosition() -> Int {
        return position
    }

    func getImage() -> UIImage {
        return image
    }

    mutating func update(with newFilter: Filter) {
        for (index, filter) in filters.enumerated() {
            if filter == newFilter {
                filters[index] = newFilter
            }
        }
    }

    mutating func update(with newName: String) {
        name = newName
    }

    mutating func update(with newPosition: Int) {
        position = newPosition
    }

    mutating func update(with newImage: UIImage) {
        image = newImage
    }

    // MARK: - Private functions

    private func getProviderFilter(from boolArray: [Bool]) -> Filter {
        return .provider(driveNow: boolArray[0], car2go: boolArray[1])
    }

    private func getMakeFilter(from boolArray: [Bool]) -> Filter {
        return .make(bmw: boolArray[0], mini: boolArray[1], mercedes: boolArray[2], smart: boolArray[3])
    }

    private func getModelFilter(from boolArray: [Bool]) -> Filter {
        return .model(mini3door: boolArray[0], mini5door: boolArray[1], miniConvertible: boolArray[2], miniClubman: boolArray[3], miniCountryman: boolArray[4], bmwI3: boolArray[5], bmw1er: boolArray[6], bmwX1: boolArray[7], bmw2erAT: boolArray[8], bmw2erConvertible: boolArray[9], smartForTwo: boolArray[10], smartRoadster: boolArray[11], smartForFour: boolArray[12], mercedesGLA: boolArray[13], mercedesCLA: boolArray[14], mercedesA: boolArray[15], mercedesB: boolArray[16])
    }

    private func getFuelTypeFilter(from boolArray: [Bool]) -> Filter {
        return .fuelType(petrol: boolArray[0], diesel: boolArray[1], electric: boolArray[2])
    }

    private func getTransmissionFilter(from boolArray: [Bool]) -> Filter {
        return .transmission(automatic: boolArray[0], manual: boolArray[1])
    }

    private func getHPFilter(from intArray: [Int]) -> Filter {
        return .hp(min: intArray[0], max: intArray[1])
    }

    private func getFuelLevelFilter(from intArray: [Int]) -> Filter {
        return .fuelLevel(min: intArray[0], max: intArray[1])
    }

    private func getDoorsFilter(from boolArray: [Bool]) -> Filter {
        return .doors(three: boolArray[0], five: boolArray[1])
    }

    private func getSeatsFilter(from boolArray: [Bool]) -> Filter {
        return .seats(two: boolArray[0], four: boolArray[1], five: boolArray[2])
    }

    private func getHiFiSystemFilter(from boolArray: [Bool]) -> Filter {
        return .hifiSystem(only: boolArray[0])
    }

    // MARK: - used by filter(vehicles:)

    private func filterByProvider(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByMake(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByModel(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByFueltype(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByTransmission(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByHP(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByFuellevel(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByDoors(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterBySeats(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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

    private func filterByHiFiSystem(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

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
