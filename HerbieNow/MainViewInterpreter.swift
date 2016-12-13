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
        
        // TODO: Überprüfe, welche Accounts verbunden sind
        // TODO: Filtersets laden
        
    }
    
    func accountButtonPressed() {
        
        // TODO: Überprüfe, ob der Account verbunden ist
        
    }
    
    func mapButtonPressed() {
        goToMapView()
    }
    
    func filtersetButtonPressed() {
        
        // TODO: Prüfe, ob der Button unbelegt oder schon mit Filterset belegt ist
        // unbelegt: createFilterset()
        // belegt: goToMapView(with: Filterset)
    
    }
    
    func filtersetButtonLongPressed() {
        
        // TODO: Anzeige von Delete Alert View
        
    }
    
}
