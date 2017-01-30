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

class SelectExternalModelOptionsPopupPresenter {

    weak var vehicleMapVC: SelectExternalModelOptionsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    init(to vehicleMapViewController: SelectExternalModelOptionsPopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

extension SelectExternalModelOptionsPopupPresenter: SelectExternalModelOptionsPopupPresenterProtocol {

}
