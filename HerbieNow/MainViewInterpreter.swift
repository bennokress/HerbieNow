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
class MainViewInterpreter {

    var presenter: MainViewPresenterProtocol
    var logic: LogicProtocol

    init(for mainVC: MainViewControllerProtocol? = nil, _ presenter: MainViewPresenterProtocol = MainViewPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = MainViewPresenter(to: mainVC)
        self.logic = Logic()

    }

    fileprivate func createFilterset() {

    }

    fileprivate func handleAPIresponse(_ response: APICallResult, presenterActionRequired: Bool) {

        // TODO: Jeweiliges API Call Result entpacken und an die passenden Stellen weiterleiten

        if presenterActionRequired {

            switch response {
            case .error(_, _, _, _):
                //                presenter.displayAlert(with: response)
                print("Let presenter show an alert for: \(response.description)")
            case .reservation(let userHasActiveReservation, let optionalReservation):
                //                userHasActiveReservation ? displayReservation(optionalReservation) : displayNoReservation()
                if userHasActiveReservation {
                    guard let reservation = optionalReservation else { fatalError("Bad format: Active Reservation was nil.") }
                    print("Let presenter show reservation: \(reservation.description)")
                } else {
                    print("Let presenter show that no reservation is active.")
                }
            case .success(let successful):
                //                successful ? presenter.letUserKnowOfSuccessfulAPIcall() : presenter.letUserKnowOfUnsuccessfulAPIcall()
                print("Let presenter show: API Call was \(successful ? "successful" : "unsuccessful").")
            case .vehicles(let vehicles):
                //                presenter.showVehiclesOnMap(vehicles)
                print("Let the presenter display the following vehicles:")
                for vehicle in vehicles {
                    print(vehicle.description)
                }
            }

        } else {

            print("Take background action (without presenter) for the following API Call Result:")
            print(response.description)

        }

    }

}

extension MainViewInterpreter: MainViewInterpreterProtocol {

    func viewDidAppear() {

        //        let configuredAccounts: [Account] = logic.getConfiguredAccounts()
        //        presenter.configureAccountButtons(with: configuredAccounts)

        let configuredFiltersets: [Int : Filterset] = logic.getConfiguredFiltersets()
        presenter.configureFiltersetButtons(with: configuredFiltersets)

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
                logic.getAvailableVehicles(from: .driveNow, around: Location(latitude: 48.183375, longitude: 11.550553)) { response in
                    self.handleAPIresponse(response, presenterActionRequired: true)
                }
        //        logic.reserveVehicle(withVIN: "WMWWG310803C16019", of: .driveNow) { response in
        //            self.handleAPIresponse(response, presenterActionRequired: true)
        //        }
        //        logic.getReservationStatus(from: .driveNow) { response in
        //            self.handleAPIresponse(response, presenterActionRequired: true)
        //        }
    }

}
