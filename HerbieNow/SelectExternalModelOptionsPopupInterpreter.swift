//
//  SelectExternalModelOptionsPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectExternalModelOptionsPopupInterpreterProtocol {

}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class SelectExternalModelOptionsPopupInterpreter {

    let appDelegate: AppDelegate

    var presenter: SelectExternalModelOptionsPopupPresenterProtocol
    var logic: LogicProtocol

    init(for vehicleMapVC: SelectExternalModelOptionsPopupViewControllerProtocol? = nil, _ presenter: SelectExternalModelOptionsPopupPresenterProtocol = SelectExternalModelOptionsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = SelectExternalModelOptionsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

extension SelectExternalModelOptionsPopupInterpreter: SelectExternalModelOptionsPopupInterpreterProtocol {

}
