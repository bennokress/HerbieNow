//
//  MainViewPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol MainViewPresenterProtocol {
    
    // This protocol contains every function, the MainViewInterpreter can call.
    
    /// Displays a checkmark on the selected filter.
    func showCheckmark(for filter: Filteroption)
    
    /// Displays no checkmark on the selected filter.
    func hideCheckmark(for filter: Filteroption)
    
    /// Activates segue to Settings View
    func showSettingsView()
    
    /// Activates segue to Map View
    func showMapView()
    
}

/// The Presenter is only called by the Interpreter and structures incoming data for easier presentation by a ViewController
class MainViewPresenter {
    
    weak var mainVC: MainViewController? // avoiding a retain cycle with this weak reference
    
    init(to mainViewController: MainViewController? = nil) {
        mainVC = mainViewController
    }
    
}

extension MainViewPresenter: MainViewPresenterProtocol {
    
    func showCheckmark(for filter: Filteroption) {
        <#code#>
    }
    
    func hideCheckmark(for filter: Filteroption) {
        <#code#>
    }
    
    func showSettingsView() {
        <#code#>
    }
    
    func showMapView() {
        <#code#>
    }
    
}
