//
//  LoginPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol LoginPopupInterpreterProtocol {
    
    
}

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class LoginPopupInterpreter {
    
    let appDelegate: AppDelegate
    
    var presenter: LoginPopupPresenterProtocol
    var logic: LogicProtocol
    
    init(for vehicleMapVC: LoginPopupViewControllerProtocol? = nil, _ presenter: LoginPopupPresenterProtocol = LoginPopupPresenter(to: nil), _ logic: LogicProtocol = Logic(), appDelegate: AppDelegate) {
        
        self.appDelegate = appDelegate
        self.presenter = LoginPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()
        
    }
    
}

extension LoginPopupInterpreter: LoginPopupInterpreterProtocol {
    
}
