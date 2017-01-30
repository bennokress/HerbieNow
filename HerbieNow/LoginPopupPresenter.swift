//
//  LoginPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol LoginPopupPresenterProtocol {
    
    
    
}

/// The Presenter is only called by the Interpreter and structures incoming data for easier presentation by a ViewController
class LoginPopupPresenter {
    
    weak var vehicleMapVC: LoginPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference
    
    init(to vehicleMapViewController: LoginPopupViewControllerProtocol? = nil) {
        vehicleMapVC = vehicleMapViewController
    }
    
}

extension LoginPopupPresenter: LoginPopupPresenterProtocol {
    
}
