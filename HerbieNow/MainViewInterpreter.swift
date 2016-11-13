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
    
    /// Called by MainViewController when one of the filter buttons is pressed.
    func filterButtonPressed(withSenderID: Int)
    
    /// Called by MainViewController when the settings button is pressed.
    func settingsButtonPressed()
    
    /// Called by MainViewController when the search button is pressed.
    func searchButtonPressed()
    
}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures. 
class MainViewInterpreter {
    
    var presenter: MainViewPresenterProtocol
    var logic: LogicProtocol
    
    init(for mainVC: MainViewController? = nil, _ presenter: MainViewPresenterProtocol = MainViewPresenter(to: nil), _ logic: LogicProtocol = Logic()) {
        
        self.presenter = MainViewPresenter(to: mainVC)
        self.logic = Logic()
        
    }
    
}

extension MainViewInterpreter: MainViewInterpreterProtocol {
    
    func filterButtonPressed(withSenderID senderID: Int) {
        
        <#convert senderID to Filteroption#>
        
        <#save state of filteroptions#>
        
        <#Presenter: show checkmark on filter button#>
    
    }
    
    func settingsButtonPressed() {
        
        <#Presenter: activate segue to Settings View#>
        
    }
    
    func searchButtonPressed() {
        
        <#call API(s) to get the current vehicle list#>

        <#filter vehicle list with selected filters#>
        
        <#Presenter: activate segue to Map View#>
        
    }
    
}
