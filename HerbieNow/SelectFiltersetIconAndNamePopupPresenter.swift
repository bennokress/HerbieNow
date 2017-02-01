//
//  SelectFiltersetIconAndNamePopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectFiltersetIconAndNamePopupPresenterProtocol {
    
    func fillPicker(with encodedIcons: [String])
    func updateAllElements(for filterset: Filterset, with encodedIcons: [String])
}

// MARK: -
class SelectFiltersetIconAndNamePopupPresenter {

    // MARK: Links

    weak var popupVC: SelectFiltersetIconAndNamePopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization

    init(to vehicleMapViewController: SelectFiltersetIconAndNamePopupViewControllerProtocol? = nil) {
        popupVC = vehicleMapViewController
    }

}

// MARK: Select Filterset Icon and Name Popup Presenter Protocol Conformance
extension SelectFiltersetIconAndNamePopupPresenter: SelectFiltersetIconAndNamePopupPresenterProtocol {
    
    func fillPicker(with encodedIcons: [String]) {
        popupVC?.fillPicker(with: encodedIcons)
    }
    
    func updateAllElements(for filterset: Filterset, with encodedIcons: [String]) {
        let newData = ViewData.filtersetNameAndIconPopupData(filterset, displayedEncodedIcons: encodedIcons)
        popupVC?.updateViewData(to: newData)
        popupVC?.updateFiltersetNameTextField(to: filterset.name)
    }

}
