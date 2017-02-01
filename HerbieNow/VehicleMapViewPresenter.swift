//
//  VehicleMapViewPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol VehicleMapViewPresenterProtocol {
    
    func centerMap(on location: Location)
    func goToMainView()
    func showVehicles(from data: ViewData)
    
}

// MARK: -
class VehicleMapViewPresenter {
    
    // MARK: Links

    weak var vehicleMapVC: VehicleMapViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization
    
    init(to vehicleMapViewController: VehicleMapViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

// MARK: - Vehicle Map View Presenter Protocol Conformance
extension VehicleMapViewPresenter: VehicleMapViewPresenterProtocol {
    
    func centerMap(on location: Location) {
        vehicleMapVC?.centerMap(on: location)
    }
    
    func goToMainView() {
        vehicleMapVC?.goBackToMainView()
    }
    
    func showVehicles(from data: ViewData) {
        if case .vehicleMapData(let vehicles) = data {
            vehicleMapVC?.showAnnotations(for: vehicles)
        }
    }
    
}
