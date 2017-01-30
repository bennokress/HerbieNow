//
//  SelectInternalModelOptionsPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectInternalModelOptionsPopupInterpreterProtocol {
    
    
}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class SelectInternalModelOptionsPopupInterpreter {
    
    let appDelegate: AppDelegate
    
    var presenter: SelectInternalModelOptionsPopupPresenterProtocol
    var logic: LogicProtocol
    
    init(for vehicleMapVC: SelectInternalModelOptionsPopupViewControllerProtocol? = nil, _ presenter: SelectInternalModelOptionsPopupPresenterProtocol = SelectInternalModelOptionsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {
        
        self.appDelegate = appDelegate
        self.presenter = SelectInternalModelOptionsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()
        
    }
    
}

extension SelectInternalModelOptionsPopupInterpreter: SelectInternalModelOptionsPopupInterpreterProtocol {
    
}
