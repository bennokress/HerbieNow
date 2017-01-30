//
//  VehicleMapInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol VehicleMapInterpreterProtocol {
    
    func viewDidLoad()
    
    func viewDidAppear()
    
    func backButtonPressed()
    
    func vehicleSelected()
}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class VehicleMapInterpreter: GeneralInterpretProtocol {
    
    let appDelegate: AppDelegate

    var presenter: VehicleMapPresenterProtocol
    var logic: LogicProtocol
    
    var mapCentered: Bool = false
    
    init(for vehicleMapVC: VehicleMapViewControllerProtocol? = nil, _ presenter: VehicleMapPresenterProtocol = VehicleMapPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = VehicleMapPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }
    
    func locationUpdated(_ location: Location) {
        if(!mapCentered){
            presenter.centerMap(on: location)
            mapCentered = true
        }
        logic.saveUpdatedLocation(location)
        presenter.showMyLocation(at: location)
    }
    
    func requestRegularLocationUpdates() {
        appDelegate.registerCurrentInterpreterForLocationUpdates(self)
        appDelegate.locationManager.requestAlwaysAuthorization()
    }


}

extension VehicleMapInterpreter: VehicleMapInterpreterProtocol {
    
    func viewDidLoad() {
        // Allow Location Updates
        // Triggers Pop-up window for location service authorization
        requestRegularLocationUpdates()
    }
    
    func viewDidAppear() {
        
    }
    
    func backButtonPressed() {
        presenter.goToMainView()
    }
    
    func vehicleSelected() {
        // TODO: implement
    }
    
}
