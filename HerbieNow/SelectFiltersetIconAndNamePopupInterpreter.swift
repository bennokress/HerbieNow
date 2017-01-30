//
//  SelectFiltersetIconAndNamePopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectFiltersetIconAndNamePopupInterpreterProtocol {

}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class SelectFiltersetIconAndNamePopupInterpreter {

    let appDelegate: AppDelegate

    var presenter: SelectFiltersetIconAndNamePopupPresenterProtocol
    var logic: LogicProtocol

    init(for vehicleMapVC: SelectFiltersetIconAndNamePopupViewControllerProtocol? = nil, _ presenter: SelectFiltersetIconAndNamePopupPresenterProtocol = SelectFiltersetIconAndNamePopupPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = SelectFiltersetIconAndNamePopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

extension SelectFiltersetIconAndNamePopupInterpreter: SelectFiltersetIconAndNamePopupInterpreterProtocol {

}
