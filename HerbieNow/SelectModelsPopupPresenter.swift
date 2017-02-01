//
//  SelectModelsPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectModelsPopupPresenterProtocol {
    
    func updateAllElements(for filterset: Filterset)

}

// MARK: -
class SelectModelsPopupPresenter {

    // MARK: Links

    weak var popupVC: SelectModelsPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization

    init(to vehicleMapViewController: SelectModelsPopupViewControllerProtocol? = nil) {
        popupVC = vehicleMapViewController
    }

}

// MARK: Select Models Popup Presenter Protocol Conformance
extension SelectModelsPopupPresenter: SelectModelsPopupPresenterProtocol {
    
    func updateAllElements(for filterset: Filterset) {
        if case .model(let mini3door, let mini5door, let miniConvertible, let miniClubman, let miniCountryman, let bmwI3, let bmw1er, let bmwX1, let bmw2erAT, let bmw2erConvertible, let smartForTwo, let smartRoadster, let smartForFour, let mercedesGLA, let mercedesCLA, let mercedesA, let mercedesB) = filterset.modelFilter {
            
            let newData = ViewData.internalModelOptionsPopupData(filterset)
            popupVC?.updateViewData(to: newData)
            popupVC?.updateModelsButtonsActiveState(mini3door: mini3door, mini5door: mini5door, miniConvertible: miniConvertible, miniClubman: miniClubman, miniCountryman: miniCountryman, bmwI3: bmwI3, bmw1er: bmw1er, bmwX1: bmwX1, bmw2erAT: bmw2erAT, bmw2erConvertible: bmw2erConvertible, smartForTwo: smartForTwo, smartRoadster: smartRoadster, smartForFour: smartForFour, mercedesGLA: mercedesGLA, mercedesCLA: mercedesCLA, mercedesA: mercedesA, mercedesB: mercedesB)
        }
    }

}
