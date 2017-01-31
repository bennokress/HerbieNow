//
//  MainViewInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import OAuthSwift

protocol MainViewInterpreterProtocol {

    func viewDidAppear()
    func userTapped(button: MainViewButton)
    func userDismissedPopup(with selectedData: ViewReturnData, via navigationAction: NavigationAction)

}

// MARK: -
class MainViewInterpreter {

    // MARK: Links
    
    let appDelegate: AppDelegate
    var presenter: MainViewPresenterProtocol
    var logic: LogicProtocol
    
    // MARK: Initialization

    init(for mainVC: MainViewControllerProtocol? = nil, _ presenter: MainViewPresenterProtocol = MainViewPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = MainViewPresenter(to: mainVC)
        self.logic = Logic()

    }
    
}

// MARK: - Location Update Delegate Conformance
extension MainViewInterpreter: LocationUpdateDelegate {
    
    func locationUpdated(_ location: Location) {
        logic.saveUpdatedLocation(location)
    }
    
}

// MARK: - Main View Interpreter Protocol Conformance
extension MainViewInterpreter: MainViewInterpreterProtocol {
    
    func viewDidAppear() {
        
        requestRegularLocationUpdates()
        
        let configuredFiltersets = logic.getConfiguredFiltersets()
        let driveNowActive = logic.isAccountConfigured(for: .driveNow)
        let car2goActive = logic.isAccountConfigured(for: .car2go)
        
        let mainViewData = ViewData.mainData(displayedFiltersets: configuredFiltersets, driveNowActive: driveNowActive, car2goActive: car2goActive)
        
        presenter.updateData(with: mainViewData)
        presenter.dismissLoadingAnimation()
        
    }
    
    func userTapped(button: MainViewButton){
        
        switch button {
        case .filterset(let filterset, let index):
            if let filterset = filterset {
                getFilteredVehicles(for: filterset)
            } else {
                createFilterset(at: index)
            }
        case .provider(let provider):
            if logic.isAccountConfigured(for: provider) {
                getFilteredVehicles(for: provider)
            } else {
                // TODO: Login with Provider
            }
        case .map:
            let driveNowConfigured = logic.isAccountConfigured(for: .driveNow)
            let car2goConfigured = logic.isAccountConfigured(for: .car2go)
            if driveNowConfigured && car2goConfigured {
                getUnfilteredVehicles()
            } else if driveNowConfigured {
                getFilteredVehicles(for: .driveNow)
            } else if car2goConfigured {
                getFilteredVehicles(for: .car2go)
            } else {
                Debug.print(.warning(source: .location(Source()), message: "Function not yet implemented (DriveNow and Car2Go are not logged in)."))
                // TODO: Alert - please login with one of the providers (option 1: DriveNow, option 2: Car2Go, option 3: cancel)
            }
        }
        
    }
    
    func userDismissedPopup(with selectedData: ViewReturnData, via navigationAction: NavigationAction) {
        switch selectedData {
        case .loginPopupReturnData, .noReturnData:
            presenter.dismissLoadingAnimation()
        case .internalModelOptionsPopupReturnData(let filterset):
            handleDismissedInternalPopup(with: filterset, via: navigationAction)
        case .externalModelOptionsPopupReturnData(let filterset):
            handleDismissedExternalPopup(with: filterset, via: navigationAction)
        case .modelsPopupReturnData(let filterset):
            handleDismissedModelsPopup(with: filterset, via: navigationAction)
        case .filtersetIconAndNamePopupReturnData(let filterset):
            handleDismissedIconAndNamePopup(with: filterset, via: navigationAction)
        }
    }
    
}

// MARK: - Internal Functions
extension MainViewInterpreter: InternalRouting {

    fileprivate func requestRegularLocationUpdates() {
        appDelegate.registerCurrentInterpreterForLocationUpdates(self)
        appDelegate.locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: Filterset Handling

    fileprivate func createFilterset(at index: Int) {
        guard index.isInRange(min: 1, max: 9) else {
            Debug.print(.error(source: .location(Source()), message: "Filterset index should only be between 1 and 9!"))
            return
        }
        var newFilterset = Filterset()
        newFilterset.update(position: index)
        let popupData = ViewData.internalModelOptionsPopupData(newFilterset)
        let internalModelOptionsPopup = View.internalModelOptions(data: popupData)
        presenter.presentPopup(internalModelOptionsPopup)
    }
    
    fileprivate func getFilteredVehicles(for filterset: Filterset) {
        logic.getAllAvailableVehicles() { response in
            guard let unfilteredVehicles: [Vehicle] = response.getDetails() else { return }
            let vehicles = filterset.filter(vehicles: unfilteredVehicles)
            self.presentVehicleMapView(with: vehicles)
        }
    }
    
    fileprivate func getFilteredVehicles(for provider: Provider) {
        logic.getAvailableVehicles(from: provider) { response in
            guard let vehicles: [Vehicle] = response.getDetails() else { return }
            self.presentVehicleMapView(with: vehicles)
        }
    }
    
    fileprivate func getUnfilteredVehicles() {
        logic.getAllAvailableVehicles() { response in
            guard let vehicles: [Vehicle] = response.getDetails() else { return }
            Debug.print(.info(source: .location(Source()), message: "Got \(vehicles.count) vehicles"))
            self.presentVehicleMapView(with: vehicles)
        }
    }
    
    // MARK: Popup Flow
    
    fileprivate func handleDismissedInternalPopup(with filterset: Filterset, via action: NavigationAction) {
        switch action {
        case .next:
            let popupData = ViewData.externalModelOptionsPopupData(filterset)
            presenter.presentPopup(.externalModelOptions(data: popupData))
        default:
            presenter.dismissLoadingAnimation()
        }
    }
    
    fileprivate func handleDismissedExternalPopup(with filterset: Filterset, via action: NavigationAction) {
        switch action {
        case .next:
            // TODO: Get fitting filters based on current filterset
            let popupData = ViewData.modelsPopupData(filterset, displayedModels: [])
            presenter.presentPopup(.models(data: popupData))
        case .back:
            let popupData = ViewData.internalModelOptionsPopupData(filterset)
            presenter.presentPopup(.internalModelOptions(data: popupData))
        default:
            presenter.dismissLoadingAnimation()
        }
    }
    
    fileprivate func handleDismissedModelsPopup(with filterset: Filterset, via action: NavigationAction) {
        switch action {
        case .next:
            // TODO: Get all icons to display
            let popupData = ViewData.filtersetNameAndIconPopupData(filterset, displayedIcons: [#imageLiteral(resourceName: "Car01"), #imageLiteral(resourceName: "Car02"), #imageLiteral(resourceName: "Car03")])
            presenter.presentPopup(.filtersetNameAndIcon(data: popupData))
        case .back:
            let popupData = ViewData.externalModelOptionsPopupData(filterset)
            presenter.presentPopup(.externalModelOptions(data: popupData))
        default:
            presenter.dismissLoadingAnimation()
        }
    }
    
    fileprivate func handleDismissedIconAndNamePopup(with filterset: Filterset, via action: NavigationAction) {
        switch action {
        case .confirm:
            // TODO: Save filterset
            viewDidAppear()
        case .back:
            // TODO: Get all icons to display
            let popupData = ViewData.filtersetNameAndIconPopupData(filterset, displayedIcons: [#imageLiteral(resourceName: "Car01"), #imageLiteral(resourceName: "Car02"), #imageLiteral(resourceName: "Car03")])
            presenter.presentPopup(.filtersetNameAndIcon(data: popupData))
        default:
            presenter.dismissLoadingAnimation()
        }
    }
    
}

// MARK: - Presenter Connection
extension MainViewInterpreter: PresenterConnection {
    
    func presentVehicleMapView(with vehicles: [Vehicle]) {
        presenter.presentVehicleMapView(with: vehicles)
    }
    
}
