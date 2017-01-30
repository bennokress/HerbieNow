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


// MARK: -
class SelectInternalModelOptionsPopupPresenter {
    
    // MARK: Links
    
    weak var vehicleMapVC: SelectInternalModelOptionsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference
    
    // MARK: Initialization
    
    init(to vehicleMapViewController: SelectInternalModelOptionsPopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }

}

// MARK: Select Internal Model Options Popup Presenter Protocol Conformance
extension SelectInternalModelOptionsPopupPresenter: SelectInternalModelOptionsPopupPresenterProtocol {

}
