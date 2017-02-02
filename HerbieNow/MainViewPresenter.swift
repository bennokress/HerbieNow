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
    func presentAlertForLogout(of provider: Provider)
    func presentAlertForFiltersetDeletion(of id: Int)
    func updateData(with viewData: ViewData)
    func dismissLoadingAnimation()

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
            mainVC?.presentDriveNowLoginPopup()
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
    
    func presentAlertForLogout(of provider: Provider) {
        mainVC?.presentAlertForLogout(of: provider)
    }
    
    func presentAlertForFiltersetDeletion(of id: Int) {
        mainVC?.presentAlertForFiltersetDeletion(of: id)
    }

    func updateData(with viewData: ViewData) {
        guard let displayedFiltersets = viewData.displayedFiltersets, let driveNowConfigured = viewData.driveNowConfigured, let car2goConfigured = viewData.car2goConfigured else {
            return
        }
        mainVC?.updateFiltersetButtons(filtersets: displayedFiltersets)
        mainVC?.updateProviderButtons(driveNow: driveNowConfigured, car2go: car2goConfigured)
    }
    
    func dismissLoadingAnimation() {
        mainVC?.dismissLoadingAnimation()
    }
    
  

}
