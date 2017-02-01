//
//  SelectExternalModelOptionsPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectExternalModelOptionsPopupPresenterProtocol {
    
    func updateAllElements(for filterset: Filterset)

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
    
    func updateAllElements(for filterset: Filterset) {
//        if case .fuelType(let petrol, let diesel, let electric) = filterset.fuelTypeFilter,
//            case .transmission(let automatic, let manual) = filterset.transmissionFilter,
//            case .hifiSystem(let onlyHiFiSystem) = filterset.hiFiSystemFilter {
//            
//            let newData = ViewData.internalModelOptionsPopupData(filterset)
//            popupVC?.updateViewData(to: newData)
//            popupVC?.updateFuelTypeButtonsActiveState(diesel: diesel, petrol: petrol, electric: electric)
//            popupVC?.updateTransmissionTypeButtonsActiveState(automatic: automatic, manual: manual)
//            popupVC?.updateHiFiSystemButtonActiveState(hifiSystemOnly: onlyHiFiSystem)
//            
//        }
    }

}
