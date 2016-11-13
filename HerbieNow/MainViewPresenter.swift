//
//  MainViewPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol MainViewPresenterProtocol {
    
    
    
}

/// The Presenter is only called by the Interpreter and structures incoming data for easier presentation by a ViewController
class MainViewPresenter {
    
    weak var mainVC: MainViewController? // avoiding a retain cycle with this weak reference
    
    init(to mainViewController: MainViewController? = nil) {
        mainVC = mainViewController
    }
    
}

extension MainViewPresenter: MainViewPresenterProtocol {
    
    
    
}
