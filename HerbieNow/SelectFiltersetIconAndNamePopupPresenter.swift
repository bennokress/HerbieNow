//
//  SelectFiltersetIconAndNamePopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

protocol SelectFiltersetIconAndNamePopupPresenterProtocol {
    
    func fillPicker(with icons: [UIImage])
    func updateAllElements(for filterset: Filterset, with icons: [UIImage])
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
    
    func fillPicker(with icons: [UIImage]) {
        popupVC?.fillPicker(with: icons)
    }
    
    func updateAllElements(for filterset: Filterset, with icons: [UIImage]) {
        let newData = ViewData.filtersetNameAndIconPopupData(filterset, displayedIcons: icons)
        popupVC?.updateViewData(to: newData)
        popupVC?.updateFiltersetNameTextField(to: filterset.name)
    }

}
