//
//  MainViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol {
    
    // This protocol contains every function, the MainViewPresenter can call.
    
    /// Performs the segue to Map View. Typically after the search button is pressed.
    func goToMapView(with filter: Filterset?)
    
    // TODO: Add arguments and documentation comment
    func displayFiltersetButtons()
    
    // TODO: Add arguments and documentation comment
    func displayAccountButtons()
    
    // TODO: Add arguments and documentation comment
    func displayWelcomeSequence()
    
}

/// ViewControllers have no logic other than what to display
class MainViewController: UIViewController {
    
    lazy var interpreter: MainViewInterpreterProtocol = MainViewInterpreter(for: self)

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setExclusiveTouchForAllButtons()
        
        // TODO: 1. Überprüfe, welche Accounts verbunden sind, wenn verbunden, ohne Transparenz
        // TODO: 2. Wenn keine Accounts verbunden sind, welcome Sequence
        // TODO: 3. Wenn einer nicht Verbunden, Plus Symbol anzeigen über logo anzeigen, zum verbinden
        // TODO: 4. Klick auf Plus - POP up mit Login-Daten eingeben -> Überprüfen + Persitent speichern
        
        // TODO: 5. Filtersets laden
        
        // TODO: 6. Filtersets + Symbol ->  Filter erstellen (View Wechsel)
        // TODO: 7. Kartenansicht -> Karte (ohne Filter) (View Wechsel)
        // TODO: 8. Einstellungen -> Einstellungen (View Wechsel)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        interpreter.viewDidAppear()
        
    }
    
    private func filtersetButtonPressed() {
        
    }
    
    private func filtersetButtonLongPressed() {
        
    }
    
    private func accountButtonPressed() {
        
    }
    
    private func mapButtonPressed() {
        
    }
    
    private func setExclusiveTouchForAllButtons() {
        
    }

}

//extension MainViewController: MainViewControllerProtocol {
//    
//    func goToMapView(with filter: Filterset? = nil) {
//        <#code#>
//    }
//    
//}
