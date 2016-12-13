//
//  MainViewInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol MainViewInterpreterProtocol {
    
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
    
    init(for mainVC: MainViewController? = nil, _ presenter: MainViewPresenterProtocol = MainViewPresenter(to: nil), _ logic: LogicProtocol = Logic()) {
        
        self.presenter = MainViewPresenter(to: mainVC)
        self.logic = Logic()
        
    }
    
    fileprivate func createFilterset() {
        
    }
    
    fileprivate func goToMapView(with filterset: Filterset? = nil) {
        
        if let selectFilterset = filterset {
            // TODO: Presenter --> zeige gefilterte Kartenansicht
        } else {
            // TODO: Presenter --> zeige ungefilterte Kartenansicht
        }
        
    }
    
}

extension MainViewInterpreter: MainViewInterpreterProtocol {
    
    func viewDidAppear() {
        
        let configuredAccounts: [Account] = logic.getConfiguredAccounts()
        // TODO: Presenter --> zeige Account-Buttons mit korrektem Status (angemeldet oder nicht) an
        
        let configuredFiltersets: [Int : Filterset] = logic.getConfiguredFiltersets()
        // TODO: Presenter --> zeige Filterset-Buttons mit korrektem Status (konfiguriert oder nicht) an
        
        // TODO: Location laden
        
    }
    
    func accountButtonPressed() {
        
        // TODO: Überprüfe, ob der Account verbunden ist
        // logic.isAccountConfigured(for: Provider)
        
    }
    
    func mapButtonPressed() {
        goToMapView()
    }
    
    func filtersetButtonPressed() {
        
        // TODO: id durch filtersetButton ID ersetzen
        let id = 1
        
        let filterset = logic.getFilterset(for: id)
        goToMapView(with: filterset)
    
    }
    
    func filtersetButtonLongPressed() {
        
        // TODO: Presenter --> Anzeige von Delete Alert View
        
    }
    
}
