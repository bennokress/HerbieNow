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
                if provider == .driveNow {
                    presenter.presentPopup(.login)
                } else if provider == .car2go {
                    logic.getUserData(from: .car2go) { _ in
                        self.getFilteredVehicles(for: provider)
                    }
                }
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
    
    fileprivate func getAllAvailableFiltersetIcons() -> [UIImage] {
        return [#imageLiteral(resourceName: "Car01"),#imageLiteral(resourceName: "Car02"),#imageLiteral(resourceName: "Car03"),#imageLiteral(resourceName: "Car04"),#imageLiteral(resourceName: "Car05"),#imageLiteral(resourceName: "Car06"),#imageLiteral(resourceName: "Car07"),#imageLiteral(resourceName: "Car08"),#imageLiteral(resourceName: "Car09"),#imageLiteral(resourceName: "Car10"),
        #imageLiteral(resourceName: "Car11"),#imageLiteral(resourceName: "Car12"),#imageLiteral(resourceName: "Car13"),#imageLiteral(resourceName: "Car14"),#imageLiteral(resourceName: "Car15"),#imageLiteral(resourceName: "Car16"),#imageLiteral(resourceName: "Car17"),#imageLiteral(resourceName: "Car18"),#imageLiteral(resourceName: "Car19"),#imageLiteral(resourceName: "Face01"),
        #imageLiteral(resourceName: "Face02"),#imageLiteral(resourceName: "Face03"),#imageLiteral(resourceName: "Face04"),#imageLiteral(resourceName: "Face05"),#imageLiteral(resourceName: "Face06"),#imageLiteral(resourceName: "Face07"),#imageLiteral(resourceName: "Face08"),#imageLiteral(resourceName: "Face09"),#imageLiteral(resourceName: "Face10"),#imageLiteral(resourceName: "Face11"),
        #imageLiteral(resourceName: "Face12"),#imageLiteral(resourceName: "Face13"),#imageLiteral(resourceName: "Face14"),#imageLiteral(resourceName: "Face15"),#imageLiteral(resourceName: "Misc01"),#imageLiteral(resourceName: "Misc02"),#imageLiteral(resourceName: "Misc03"),#imageLiteral(resourceName: "Misc04"),#imageLiteral(resourceName: "Misc05"),#imageLiteral(resourceName: "Misc06"),
        #imageLiteral(resourceName: "Misc07"),#imageLiteral(resourceName: "Misc08"),#imageLiteral(resourceName: "Misc09"),#imageLiteral(resourceName: "Misc10"),#imageLiteral(resourceName: "Misc11"),#imageLiteral(resourceName: "Misc12"),#imageLiteral(resourceName: "Misc13"),#imageLiteral(resourceName: "Misc14"),#imageLiteral(resourceName: "Misc15"),#imageLiteral(resourceName: "Misc16"),
        #imageLiteral(resourceName: "Misc17"),#imageLiteral(resourceName: "Misc18"),#imageLiteral(resourceName: "Misc19"),#imageLiteral(resourceName: "Misc20"),#imageLiteral(resourceName: "Misc21")]
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
            let popupData = ViewData.filtersetNameAndIconPopupData(filterset, displayedIcons: getAllAvailableFiltersetIcons())
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
            // TODO: Get fitting filters based on current filterset
            let popupData = ViewData.modelsPopupData(filterset, displayedModels: [])
            presenter.presentPopup(.models(data: popupData))
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
