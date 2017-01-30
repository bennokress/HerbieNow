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

    func dasIstNurEineTestfunktionUmMalZeugAusDemModelLaufenZuLassenOhneMuehsamFrameworksInEinenPlaygroundZuImportieren()

    // This protocol contains every function, the MainViewController can call.

    func viewDidAppear()

    func providerButtonPressed(for provider: Provider)

    func mapButtonPressed()

    func filtersetButtonPressed(id: Int)

    func filtersetButtonLongPressed(id: Int)

}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class MainViewInterpreter: GeneralInterpretProtocol {

    let appDelegate: AppDelegate

    var presenter: MainViewPresenterProtocol
    var logic: LogicProtocol

    init(for mainVC: MainViewControllerProtocol? = nil, _ presenter: MainViewPresenterProtocol = MainViewPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {

        self.appDelegate = appDelegate
        self.presenter = MainViewPresenter(to: mainVC)
        self.logic = Logic()

    }

    func locationUpdated(_ location: Location) {
        logic.saveUpdatedLocation(location)
        let labelText = "New Location\n\nLatitude:\n\(location.latitude)\nLongitude:\n\(location.longitude)"
        presenter.display(message: labelText)
    }

    func requestRegularLocationUpdates() {
        appDelegate.registerCurrentInterpreterForLocationUpdates(self)
        appDelegate.locationManager.requestAlwaysAuthorization()
    }

    fileprivate func createFilterset() {

    }

    fileprivate func handleAPIresponse(_ response: APICallResult, presenterActionRequired: Bool) {

        // TODO: Jeweiliges API Call Result entpacken und an die passenden Stellen weiterleiten

        if presenterActionRequired {

            switch response {
            case .error(_, _, _, _):
                //                presenter.displayAlert(with: response)
                print(Debug.info(source: (name(of: self), #function), message: "Let presenter show an alert for: \(response.description)"))
            case .reservation(let userHasActiveReservation, let optionalReservation):
                //                userHasActiveReservation ? displayReservation(optionalReservation) : displayNoReservation()
                if userHasActiveReservation {
                    guard let reservation = optionalReservation else { fatalError("Bad format: Active Reservation was nil.") }
                    print(Debug.info(source: (name(of: self), #function), message: "Let presenter show reservation: \(reservation.description)"))
                } else {
                    print(Debug.info(source: (name(of: self), #function), message: "Let presenter show that no reservation is active."))
                }
            case .success(let successful):
                //                successful ? presenter.letUserKnowOfSuccessfulAPIcall() : presenter.letUserKnowOfUnsuccessfulAPIcall()
                print(Debug.info(source: (name(of: self), #function), message: "Let presenter show: API Call was \(successful ? "successful" : "unsuccessful")."))
            case .vehicles(let vehicles):
                print(Debug.info(source: (name(of: self), #function), message: "Let map show \(vehicles.count) vehicles."))
                //                                presenter.showVehiclesOnMap(vehicles)
                //                print(Debug.info(source: (name(of: self), #function), message: "Let the presenter display the following \(vehicles.count) vehicles:"))
                //                for vehicle in vehicles {
                //                    print(Debug.list(message: vehicle.description, indent: 1))
                //                }

                // TODO: Test-Filter entfernen
                let filterString = "11:0111:11111111111111111:111:11:000200:000100:11:111:0:1:myFilterName:imageCodedIn64"
                var testFilterset = Filterset(from: filterString)
                testFilterset.update(with: .provider(driveNow: true, car2go: false))
                print(testFilterset.asString)
                //                let filteredVehicles = testFilterset.filter(vehicles: vehicles)
                //                print(Debug.event(message: "Filtered: \(filteredVehicles.count) Vehicles (= \(vehicles.count - filteredVehicles.count) less)"))
                //                for vehicle in filteredVehicles {
                //                    print(Debug.list(message: vehicle.description, indent: 1))
            //                }
            case .credential(let credential):
                print(Debug.info(source: (name(of: self), #function), message: "Token: \(credential.oauthToken)"))
                print(Debug.info(source: (name(of: self), #function), message: "Secret: \(credential.oauthTokenSecret)"))
            }

        } else {

            print(Debug.info(source: (name(of: self), #function), message: "Background action for API Call Result: \(response.description)"))

        }

    }

}

extension MainViewInterpreter: MainViewInterpreterProtocol {

    func viewDidAppear() {

        //        let configuredAccounts: [Account] = logic.getConfiguredAccounts()
        //        presenter.configureAccountButtons(with: configuredAccounts)

        let configuredFiltersets: [Int : Filterset] = logic.getConfiguredFiltersets()
        presenter.configureFiltersetButtons(with: configuredFiltersets)

        // Allow Location Updates
        // Triggers Pop-up window for location service authorization
        requestRegularLocationUpdates()

    }

    func providerButtonPressed(for provider: Provider) {

        // TODO: Überprüfe, ob der Account verbunden ist
        // logic.isAccountConfigured(for: Provider)

    }

    func mapButtonPressed() {
        presenter.goToMapView()
    }

    func filtersetButtonPressed(id: Int) {

        // let filterset = logic.getFilterset(for: id)

        // TODO: logic.getVehicles (for all accounts of filterset)
        // TODO: filter vehicles according to filterset and save as filteredVehicles

        let filterset = Filterset(from: "00:0000:00000000000000000:000:00:000000:000000:00:000:0:0:name:imagecoded")
        presenter.goToMapView(with: filterset)

    }

    func filtersetButtonLongPressed(id: Int) {

        // TODO: richtiges filterset herausfinden und übergeben
        // presenter.showDeleteFiltersetAlert(for: filterset)

    }

    // Das da unten kann dann später mal weg ...

    func dasIstNurEineTestfunktionUmMalZeugAusDemModelLaufenZuLassenOhneMuehsamFrameworksInEinenPlaygroundZuImportieren() {
        //        logic.getUserData(from: .car2go) { response in
        //            self.handleAPIresponse(response, presenterActionRequired: false)
        //        }
        //        logic.login(with: .driveNow, as: "account@bennokress.de", withPassword: "XXX") { response in
        //            self.handleAPIresponse(response, presenterActionRequired: true)
        //        }
        // logic.getAvailableVehicles(from: .driveNow, around: Location(latitude: 48.183375, longitude: 11.550553)) { response in
        //    self.handleAPIresponse(response, presenterActionRequired: true)
        // }
        //        logic.login(with: .car2go) { (response) in
        //            self.handleAPIresponse(response, presenterActionRequired: true)
        //        }

        //        logic.getAvailableVehicles(from: .car2go, around: Location(latitude: 53.434236, longitude: 10.356674)) { response in
        //            self.handleAPIresponse(response, presenterActionRequired: true)
        //        }

        //        logic.reserveVehicle(withVIN: "WMWWG310803C16019", of: .driveNow) { response in
        //            self.handleAPIresponse(response, presenterActionRequired: true)
        //        }
        //        logic.getReservationStatus(from: .driveNow) { response in
        //            self.handleAPIresponse(response, presenterActionRequired: true)
        //        }
    }

}
