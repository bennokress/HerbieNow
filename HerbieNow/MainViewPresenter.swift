//
//  MainViewPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol MainViewPresenterProtocol {

    func presentVehicleMapView(with vehicles: [Vehicle])
    func presentPopup(_ popup: View)
    func configureFiltersetButtons(with filtersets: [Int : Filterset])
    func showDeleteFiltersetAlert(for filterset: Filterset)
    func display(message: String)

}

// MARK: -
class MainViewPresenter {

    // MARK: Links
    
    weak var mainVC: MainViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization
    
    init(to mainViewController: MainViewControllerProtocol? = nil) {
        mainVC = mainViewController
    }

}

// MARK: - Main View Presenter Protocol Conformance
extension MainViewPresenter: MainViewPresenterProtocol {

    func presentVehicleMapView(with vehicles: [Vehicle]) {
        let vehicleMapData = ViewData.vehicleMapData(displayedVehicles: vehicles)
        mainVC?.presentVehicleMapView(with: vehicleMapData)
    }
    
    func presentPopup(_ popup: View) {
        switch popup {
        case .login:
            mainVC?.presentLoginPopup()
        case .internalModelOptions(let popupData):
            mainVC?.presentSelectInternalModelOptionsPopup(with: popupData)
        case .externalModelOptions(let popupData):
            mainVC?.presentSelectExternalModelOptionsPopup(with: popupData)
        case .models(let popupData):
            mainVC?.presentSelectModelsPopup(with: popupData)
        case .filtersetNameAndIcon(let popupData):
            mainVC?.presentSelectFiltersetIconAndNamePopup(with: popupData)
        default:
            Debug.print(.error(source: .location(Source()), message: "No fitting Popup View Data received"))
            break
        }
    }

    func configureFiltersetButtons(with filtersets: [Int : Filterset]) {
        // TODO: activate or deactivate filterset buttons
    }

    func showDeleteFiltersetAlert(for filterset: Filterset) {
        // TODO: present alert
    }

    func display(message: String) {
        // mainVC . do something
    }

}

// MARK: - Default Implementation
extension MainViewPresenterProtocol {
    
    func goToMapView(with filterset: Filterset? = nil) {
        goToMapView(with: filterset)
    }
    
}
