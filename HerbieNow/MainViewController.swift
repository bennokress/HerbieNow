//
//  MainViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol: class {
    
    // This protocol contains every function, the MainViewPresenter can call.
    
    /// Performs the segue to Map View. Typically after the search button is pressed.
    func goToMapView(with filterset: Filterset)
    
    // TODO: Add documentation comment
    func goToMapViewWithoutFilter()
    
    // TODO: Add arguments and documentation comment
    func displayFiltersetButtons()
    
    // TODO: Add arguments and documentation comment
    func displayAccountButtons()
    
    // TODO: Add arguments and documentation comment
    func displayWelcomeSequence()
    
    // TODO: Maybe change to filterset ID? Add documentation comment
    func showDeleteFiltersetAlert(for filterset: Filterset)
    
}

/// ViewControllers have no logic other than what to display
class MainViewController: UIViewController {
    
    lazy var interpreter: MainViewInterpreterProtocol = MainViewInterpreter(for: self)

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setExclusiveTouchForAllButtons()
    
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
//    func goToMapView(with filterset: Filterset? = nil) {
//        
//    }
//    
//}
