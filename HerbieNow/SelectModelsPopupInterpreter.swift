//
//  SelectModelsPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectModelsPopupInterpreterProtocol {

}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class SelectModelsPopupInterpreter {

    let appDelegate: AppDelegate

    var presenter: SelectModelsPopupPresenterProtocol
    var logic: LogicProtocol

    init(for vehicleMapVC: SelectModelsPopupViewControllerProtocol? = nil, _ presenter: SelectModelsPopupPresenterProtocol = SelectModelsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = SelectModelsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

extension SelectModelsPopupInterpreter: SelectModelsPopupInterpreterProtocol {

}
