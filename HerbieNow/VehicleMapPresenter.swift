//
//  VehicleMapPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol VehicleMapPresenterProtocol {
    
    func centerMap(on location: Location)
    
    func showMyLocation(at location: Location)
    
}

/// The Presenter is only called by the Interpreter and structures incoming data for easier presentation by a ViewController
class VehicleMapPresenter {
    
    weak var vehicleMapVC: VehicleMapViewControllerProtocol? // avoiding a retain cycle with this weak reference
    
    init(to vehicleMapViewController: VehicleMapViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }
    
}

extension VehicleMapPresenter: VehicleMapPresenterProtocol {
    
    func centerMap(on location: Location) {
        vehicleMapVC?.centerMap(on: location)
    }
    
    func showMyLocation(at location: Location) {
        vehicleMapVC?.showMyLocation(at: location)
    }
    
}
