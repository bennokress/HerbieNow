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

// MARK: -
class SelectModelsPopupPresenter {

    // MARK: Links

    weak var vehicleMapVC: SelectModelsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization

    init(to vehicleMapViewController: SelectModelsPopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

// MARK: Select Models Popup Presenter Protocol Conformance
extension SelectModelsPopupPresenter: SelectModelsPopupPresenterProtocol {

}
