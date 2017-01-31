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

// MARK: -
class SelectFiltersetIconAndNamePopupPresenter {

    // MARK: Links

    weak var vehicleMapVC: SelectFiltersetIconAndNamePopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization

    init(to vehicleMapViewController: SelectFiltersetIconAndNamePopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

// MARK: Select Filterset Icon and Name Popup Presenter Protocol Conformance
extension SelectFiltersetIconAndNamePopupPresenter: SelectFiltersetIconAndNamePopupPresenterProtocol {

}
