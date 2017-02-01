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

    weak var popupVC: SelectExternalModelOptionsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization

    init(to vehicleMapViewController: SelectExternalModelOptionsPopupViewControllerProtocol? = nil) {
        popupVC = vehicleMapViewController
    }

}

// MARK: Select External Model Options Popup Presenter Protocol Conformance
extension SelectExternalModelOptionsPopupPresenter: SelectExternalModelOptionsPopupPresenterProtocol {
    
    func updateAllElements(for filterset: Filterset) {
        if case .seats(let twoSeats, let fourSeats, let fiveSeats) = filterset.seatsFilter,
            case .doors(let threeDoors, let fiveDoors) = filterset.doorsFilter,
            case .hp(let minHP, let maxHP) = filterset.hpFilter,
            case .fuelLevel(let minFuelLevel, let maxFuelLevel) = filterset.fuelLevelFilter {
            
            let newData = ViewData.internalModelOptionsPopupData(filterset)
            popupVC?.updateViewData(to: newData)
            popupVC?.updateSeatsButtonsActiveState(two: twoSeats, four: fourSeats, five: fiveSeats)
            popupVC?.updateDoorsButtonsActiveState(three: threeDoors, five: fiveDoors)
            popupVC?.updateHorsePowerLabelTexts(min: minHP, max: maxHP)
            popupVC?.updateFuelLevelLabelTexts(min: minFuelLevel, max: maxFuelLevel)
        }
    }

}
