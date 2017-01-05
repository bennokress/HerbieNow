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
        return fullList
    }

    fileprivate func filterByModel(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
    }

    fileprivate func filterByFueltype(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
    }

    fileprivate func filterByTransmission(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
    }

    fileprivate func filterByHP(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
    }

    fileprivate func filterByFuellevel(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
    }

    fileprivate func filterByDoors(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
    }

    fileprivate func filterBySeats(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
    }

    fileprivate func filterByHiFiSystem(_ fullList: [Vehicle], with filter: Filter) -> [Vehicle] {
        return fullList
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
