//
//  SelectInternalModelOptionsPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectInternalModelOptionsPopupPresenterProtocol {

}

class SelectInternalModelOptionsPopupPresenter {

    weak var vehicleMapVC: SelectInternalModelOptionsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    init(to vehicleMapViewController: SelectInternalModelOptionsPopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

extension SelectInternalModelOptionsPopupPresenter: SelectInternalModelOptionsPopupPresenterProtocol {

}
