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

}

extension MainViewInterpreter: MainViewInterpreterProtocol {

    func viewDidAppear() {

        let configuredAccounts: [Account] = logic.getConfiguredAccounts()
        presenter.configureAccountButtons(with: configuredAccounts)

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
        //        logic.getAvailableVehicles(from: .driveNow, around: 48.183402, 11.550423)
        logic.getUserData(from: .driveNow)
    }

}
