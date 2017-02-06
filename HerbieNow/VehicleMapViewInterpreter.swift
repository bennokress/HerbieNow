//
//  VehicleMapViewInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol VehicleMapViewInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?)
    
    // MARK: UI Interaction
    func backButtonPressed()
    func performReservation(for vehicle: Vehicle)
    
}

// MARK: -
class VehicleMapViewInterpreter {
    
    // MARK: Links
    
    let appDelegate: AppDelegate
    var presenter: VehicleMapViewPresenterProtocol
    var logic: LogicProtocol
    
    // MARK: Data & Settings
    
    var mapCentered: Bool = false
    
    // MARK: Initialization
    
    init(for vehicleMapVC: VehicleMapViewControllerProtocol? = nil, _ presenter: VehicleMapViewPresenterProtocol = VehicleMapViewPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = VehicleMapViewPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

// MARK: - Location Update Delegate Conformance
extension VehicleMapViewInterpreter: LocationUpdateDelegate {
    
    func locationUpdated(_ location: Location) {
        if(!mapCentered){
            presenter.centerMap(on: location)
            mapCentered = true
        }
        logic.saveUpdatedLocation(location) // FIXME: Is this neccessary???
    }
    
}

// MARK: - Vehicle Map View Interpreter Protocol Conformance
extension VehicleMapViewInterpreter: VehicleMapViewInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?) {
        requestRegularLocationUpdates()
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No View Data found"))
            return
        }
        presenter.showVehicles(from: viewData)
    }
    
    func backButtonPressed() {
        presenter.goToMainView()
    }
    
    func performReservation(for vehicle: Vehicle) {
        logic.reserveVehicle(withVIN: vehicle.vin, of: vehicle.provider) { response in
            if (response.getDetails() == true){
                self.presenter.showConfirmationPopUp()
            } else {
                self.presenter.showFailedPopUp()
            }
        }   
    }
    
}

extension VehicleMapViewInterpreter: InternalRouting {
    
    fileprivate func requestRegularLocationUpdates() {
        appDelegate.registerCurrentInterpreterForLocationUpdates(self)
        appDelegate.locationManager.requestAlwaysAuthorization()
    }
    
}
