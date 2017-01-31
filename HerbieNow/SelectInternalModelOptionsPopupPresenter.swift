//
//  SelectInternalModelOptionsPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectInternalModelOptionsPopupPresenterProtocol {

    func updateAllElements(for filterset: Filterset)
    
}


// MARK: -
class SelectInternalModelOptionsPopupPresenter {
    
    // MARK: Links
    
    weak var popupVC: SelectInternalModelOptionsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference
    
    // MARK: Initialization
    
    init(to vehicleMapViewController: SelectInternalModelOptionsPopupViewControllerProtocol? = nil) {
        popupVC = vehicleMapViewController
    }

}

// MARK: Select Internal Model Options Popup Presenter Protocol Conformance
extension SelectInternalModelOptionsPopupPresenter: SelectInternalModelOptionsPopupPresenterProtocol {

    func updateAllElements(for filterset: Filterset) {
        if case .fuelType(let petrol, let diesel, let electric) = filterset.fuelTypeFilter,
            case .transmission(let automatic, let manual) = filterset.transmissionFilter,
            case .hifiSystem(let onlyHiFiSystem) = filterset.hiFiSystemFilter {
            
            let newData = ViewData.internalModelOptionsPopupData(filterset)
            popupVC?.updateViewData(to: newData)
            popupVC?.updateFuelTypeButtonsActiveState(diesel: diesel, petrol: petrol, electric: electric)
            popupVC?.updateTransmissionTypeButtonsActiveState(automatic: automatic, manual: manual)
            popupVC?.updateHiFiSystemButtonActiveState(hifiSystemOnly: onlyHiFiSystem)
            
        }
    }
    
}
