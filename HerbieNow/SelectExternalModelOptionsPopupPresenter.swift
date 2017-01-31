//
//  SelectExternalModelOptionsPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectExternalModelOptionsPopupPresenterProtocol {

}

// MARK: -
class SelectExternalModelOptionsPopupPresenter {

    // MARK: Links

    weak var vehicleMapVC: SelectExternalModelOptionsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization

    init(to vehicleMapViewController: SelectExternalModelOptionsPopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

// MARK: Select External Model Options Popup Presenter Protocol Conformance
extension SelectExternalModelOptionsPopupPresenter: SelectExternalModelOptionsPopupPresenterProtocol {

}
