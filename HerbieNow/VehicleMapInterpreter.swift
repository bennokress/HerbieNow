//
//  VehicleMapInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol VehicleMapInterpreterProtocol {

}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class VehicleMapInterpreter {

    let appDelegate: AppDelegate

    var presenter: VehicleMapPresenterProtocol
    var logic: LogicProtocol

    init(for vehicleMapVC: VehicleMapViewControllerProtocol? = nil, _ presenter: VehicleMapPresenterProtocol = VehicleMapPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = VehicleMapPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

extension VehicleMapInterpreter: VehicleMapInterpreterProtocol {

}
