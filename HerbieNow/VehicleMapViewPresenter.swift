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
    
    func showMyLocation(at location: Location)
    
    func goToMainView()
    
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
    
    func showMyLocation(at location: Location) {
        vehicleMapVC?.showMyLocation(at: location)
    }
    
    func goToMainView() {
        vehicleMapVC?.goBackToMainView()
    }
    
}