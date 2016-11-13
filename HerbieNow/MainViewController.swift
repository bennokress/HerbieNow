//
//  MainViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol {
    
    // This Protocol contains every function, the presenter can call.
    
    /// Displays a checkmark at the given filterbutton. Typically after a previously deactivated button is pressed.
    func activate(filter: Filteroption)
    
    /// Removes the checkmark from the given filterbutton. Typically after a previously activated button is pressed.
    func deactivate(filter: Filteroption)
    
    /// Performs the segue to Map View. Typically after the search button is pressed.
    func goToMapView()
    
    /// Performs the segue to Settings View. Typically after the settings button is pressed.
    func goToSettingsView()
    
}

/// ViewControllers have no logic other than what to display
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension MainViewController: MainViewControllerProtocol {
    
    func activate(filter: Filteroption) {
        <#code#>
    }
    
    func deactivate(filter: Filteroption) {
        <#code#>
    }
    
    func goToMapView() {
        <#code#>
    }
    
    func goToSettingsView() {
        <#code#>
    }
    
}
