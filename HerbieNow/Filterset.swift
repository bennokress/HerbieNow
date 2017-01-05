//
//  Filterset.swift
//  HerbieNow
//
//  Created by Benno Kress on 05.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol FiltersetProtocol {

    func filter(vehicles: [Vehicle]) -> [Vehicle]

}

struct Filterset {

    let filters: [Filter]

    init(from initString: String) {
        filters = []
    }

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

    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func filterByModel(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {

        var filteredVehicles: [Vehicle] = []

        // swiftlint:disable:next line_length
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
                case .mercedesAseries:
                    if mercedesAFilterActivated { filteredVehicles.append(vehicle) }
                case .mercedesBseries:
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
                if (vehicle.hp >= minHP && vehicle.hp <= maxHP) {
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
                if (vehicle.fuelLevel >= minFuelLevel && vehicle.fuelLevel <= maxFuelLevel) {
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
                if(vehicle.hasHiFiSystem || (!vehicle.hasHiFiSystem && !onlyFilterActivated)) {
                    filteredVehicles.append(vehicle)
                }
            }
        }

        return filteredVehicles
    }

}

extension Filterset: FiltersetProtocol {

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

}
