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
    
}

extension Filterset: FiltersetProtocol {
    
    func filter(vehicles: [Vehicle]) -> [Vehicle] {
        
        var filteredVehicles: [Vehicle] = vehicles
        
        for filter in filters {
            filteredVehicles = filter.vehicles(filteredVehicles)
        }
        
        return filteredVehicles
        
    }
    
}
