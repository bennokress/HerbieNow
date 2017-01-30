//
//  SelectFiltersetIconAndNamePopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectFiltersetIconAndNamePopupPresenterProtocol {

}

/// The Presenter is only called by the Interpreter and structures incoming data for easier presentation by a ViewController
class SelectFiltersetIconAndNamePopupPresenter {

    weak var vehicleMapVC: SelectFiltersetIconAndNamePopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    init(to vehicleMapViewController: SelectFiltersetIconAndNamePopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

extension SelectFiltersetIconAndNamePopupPresenter: SelectFiltersetIconAndNamePopupPresenterProtocol {

}
