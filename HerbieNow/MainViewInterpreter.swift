//
//  MainViewInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol MainViewInterpreterProtocol {

    func dasIstNurEineTestfunktionUmMalZeugAusDemModelLaufenZuLassenOhneMuehsamFrameworksInEinenPlaygroundZuImportieren()

    // This protocol contains every function, the MainViewController can call.

    func viewDidAppear()

    func accountButtonPressed()

    func mapButtonPressed()

    func filtersetButtonPressed()

    func filtersetButtonLongPressed()

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
                print(Debug.info(class: self, func: #function, message: "Let presenter show an alert for: \(response.description)"))
            case .reservation(let userHasActiveReservation, let optionalReservation):
                //                userHasActiveReservation ? displayReservation(optionalReservation) : displayNoReservation()
                if userHasActiveReservation {
                    guard let reservation = optionalReservation else { fatalError("Bad format: Active Reservation was nil.") }
                    print(Debug.info(class: self, func: #function, message: "Let presenter show reservation: \(reservation.description)"))
                } else {
                    print(Debug.info(class: self, func: #function, message: "Let presenter show that no reservation is active."))
                }
            case .success(let successful):
                //                successful ? presenter.letUserKnowOfSuccessfulAPIcall() : presenter.letUserKnowOfUnsuccessfulAPIcall()
                print(Debug.info(class: self, func: #function, message: "Let presenter show: API Call was \(successful ? "successful" : "unsuccessful")."))
            case .vehicles(let vehicles):
                //                presenter.showVehiclesOnMap(vehicles)
                print(Debug.info(class: self, func: #function, message: "Let the presenter display the following vehicles:"))
                for vehicle in vehicles {
                    print(Debug.list(message: vehicle.description, indent: 1))
                }
            }

        } else {

            print(Debug.info(class: self, func: #function, message: "Background action for API Call Result: \(response.description)"))

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

    func accountButtonPressed() {

        // TODO: Überprüfe, ob der Account verbunden ist
        // logic.isAccountConfigured(for: Provider)

    }

    func mapButtonPressed() {
        presenter.goToMapView()
    }

    func filtersetButtonPressed() {

        // TODO: id durch filtersetButton ID ersetzen
        let id = 1

        let filterset = logic.getFilterset(for: id)
        presenter.goToMapView(with: filterset)

    }

    func filtersetButtonLongPressed() {

        // TODO: richtiges filterset herausfinden und übergeben
        // presenter.showDeleteFiltersetAlert(for: filterset)

    }

    // Das da unten kann dann später mal weg ...

    func dasIstNurEineTestfunktionUmMalZeugAusDemModelLaufenZuLassenOhneMuehsamFrameworksInEinenPlaygroundZuImportieren() {
        //        logic.getUserData(from: .driveNow) { response in
        //            self.handleAPIresponse(response, presenterActionRequired: false)
        //        }
        //        logic.getAvailableVehicles(from: .driveNow, around: Location(latitude: 48.183375, longitude: 11.550553)) { response in
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
