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
    
    
    
}
