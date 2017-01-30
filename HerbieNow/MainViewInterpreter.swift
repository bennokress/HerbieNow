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
        
        //        let configuredAccounts: [Account] = logic.getConfiguredAccounts()
        //        presenter.configureAccountButtons(with: configuredAccounts)
        
        let configuredFiltersets: [Int : Filterset] = logic.getConfiguredFiltersets()
        presenter.configureFiltersetButtons(with: configuredFiltersets)
        requestRegularLocationUpdates()
        
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
            getFilteredVehicles(for: provider)
        case .map:
            getUnfilteredVehicles()
        }
        
    }
    
    func userDismissedPopup(with selectedData: ViewReturnData, via navigationAction: NavigationAction) {
        // TODO: Handle this
        Debug.print(.error(source: .location(Source()), message: "Popup dismissed ... handling not implemented!"))
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
            self.presentVehicleMapView(with: vehicles)
        }
    }
    
    // MARK: API Handling

    fileprivate func handleAPIresponse(_ response: APICallResult, presenterActionRequired: Bool) {

        // TODO: Jeweiliges API Call Result entpacken und an die passenden Stellen weiterleiten

        if presenterActionRequired {

            switch response {
            case .error(_, _, _, _):
                //                presenter.displayAlert(with: response)
                Debug.print(.info(source: .location(Source()), message: "Let presenter show an alert for: \(response.description)"))
            case .reservation(let userHasActiveReservation, let optionalReservation):
                //                userHasActiveReservation ? displayReservation(optionalReservation) : displayNoReservation()
                if userHasActiveReservation {
                    guard let reservation = optionalReservation else { fatalError("Bad format: Active Reservation was nil.") }
                    Debug.print(.info(source: .location(Source()), message: "Let presenter show reservation: \(reservation.description)"))
                } else {
                    Debug.print(.info(source: .location(Source()), message: "Let presenter show that no reservation is active."))
                }
            case .success(let successful):
                //                successful ? presenter.letUserKnowOfSuccessfulAPIcall() : presenter.letUserKnowOfUnsuccessfulAPIcall()
                Debug.print(.info(source: .location(Source()), message: "Let presenter show: API Call was \(successful ? "successful" : "unsuccessful")."))
            case .vehicles(let vehicles):
                Debug.print(.info(source: .location(Source()), message: "Let map show \(vehicles.count) vehicles."))
                //                                presenter.showVehiclesOnMap(vehicles)
                //                Debug.print(.info(source: .location(Source()), message: "Let the presenter display the following \(vehicles.count) vehicles:"))
                //                for vehicle in vehicles {
                //                    print(Debug.list(message: vehicle.description, indent: 1))
                //                }

                // TODO: Test-Filter entfernen
                let filterString = "11:0111:11111111111111111:111:11:000200:000100:11:111:0:1:myFilterName:imageCodedIn64"
                var testFilterset = Filterset(from: filterString)
                testFilterset.update(filter: .provider(driveNow: true, car2go: false))
                print(testFilterset.asString)
                //                let filteredVehicles = testFilterset.filter(vehicles: vehicles)
                //                Debug.print(.event(source: .location(Source()), description: "Filtered: \(filteredVehicles.count) Vehicles (= \(vehicles.count - filteredVehicles.count) less)"))
                //                for vehicle in filteredVehicles {
                //                    print(Debug.list(message: vehicle.description, indent: 1))
            //                }
            case .credential(let credential):
                Debug.print(.info(source: .location(Source()), message: "Token: \(credential.oauthToken)"))
                Debug.print(.info(source: .location(Source()), message: "Secret: \(credential.oauthTokenSecret)"))
            }

        } else {

            Debug.print(.info(source: .location(Source()), message: "Background action for API Call Result: \(response.description)"))

        }

    }

}

// MARK: - Presenter Connection
extension MainViewInterpreter: PresenterConnection {
    
    func presentVehicleMapView(with vehicles: [Vehicle]) {
        presenter.presentVehicleMapView(with: vehicles)
    }
    
}
