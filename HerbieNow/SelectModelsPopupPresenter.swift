//
//  SelectModelsPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectModelsPopupPresenterProtocol {

}

/// The Presenter is only called by the Interpreter and structures incoming data for easier presentation by a ViewController
class SelectModelsPopupPresenter {

    weak var vehicleMapVC: SelectModelsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    init(to vehicleMapViewController: SelectModelsPopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

extension SelectModelsPopupPresenter: SelectModelsPopupPresenterProtocol {

}
