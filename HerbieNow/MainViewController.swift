//
//  MainViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import SwiftSpinner

protocol MainViewControllerProtocol: class {

    // MARK: UI Configuration
    func updateFiltersetButtons(filtersets: [Filterset?], providers: [Bool])
    func dismissLoadingAnimation()
    
    // MARK: Segues and Popup Presentation
    func presentVehicleMapView(with data: ViewData)
    func presentLoginPopup()
    func presentSelectInternalModelOptionsPopup(with data: ViewData)
    func presentSelectExternalModelOptionsPopup(with data: ViewData)
    func presentSelectModelsPopup(with data: ViewData)
    func presentSelectFiltersetIconAndNamePopup(with data: ViewData)

}

// MARK: -
class MainViewController: UIViewController {
    
    lazy var interpreter: MainViewInterpreterProtocol = MainViewInterpreter(for: self, appDelegate: UIApplication.shared.delegate as! AppDelegate)
    
    // MARK: Data
    
    var displayedFiltersets: [Filterset?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]

    // MARK: UI Elements
    
    @IBOutlet fileprivate weak var filterset1Button: UIButton!
    @IBOutlet fileprivate weak var filterset2Button: UIButton!
    @IBOutlet fileprivate weak var filterset3Button: UIButton!
    @IBOutlet fileprivate weak var filterset4Button: UIButton!
    @IBOutlet fileprivate weak var filterset5Button: UIButton!
    @IBOutlet fileprivate weak var filterset6Button: UIButton!
    @IBOutlet fileprivate weak var filterset7Button: UIButton!
    @IBOutlet fileprivate weak var filterset8Button: UIButton!
    @IBOutlet fileprivate weak var filterset9Button: UIButton!

    @IBOutlet fileprivate weak var filterset1Label: UILabel!
    @IBOutlet fileprivate weak var filterset2Label: UILabel!
    @IBOutlet fileprivate weak var filterset3Label: UILabel!
    @IBOutlet fileprivate weak var filterset4Label: UILabel!
    @IBOutlet fileprivate weak var filterset5Label: UILabel!
    @IBOutlet fileprivate weak var filterset6Label: UILabel!
    @IBOutlet fileprivate weak var filterset7Label: UILabel!
    @IBOutlet fileprivate weak var filterset8Label: UILabel!
    @IBOutlet fileprivate weak var filterset9Label: UILabel!

    @IBOutlet fileprivate weak var driveNowButton: UIButton!
    @IBOutlet fileprivate weak var car2goButton: UIButton!
    @IBOutlet fileprivate weak var goToMapButton: UIButton!
    
    // MARK: Mandatory View Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        Debug.print(.event(source: .location(Source()), description: "View Did Load"))
        setExclusiveTouchForAllButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Debug.print(.event(source: .location(Source()), description: "View Did Appear"))
        interpreter.viewDidAppear()
    }
    
    // MARK: UI Element Interaction Functions

    @IBAction func filtersetButtonPressed(_ sender: UIButton) {
        let id: Int
        switch sender {
        case filterset1Button:
            id = 1
        case filterset2Button:
            id = 2
        case filterset3Button:
            id = 3
        case filterset4Button:
            id = 4
        case filterset5Button:
            id = 5
        case filterset6Button:
            id = 6
        case filterset7Button:
            id = 7
        case filterset8Button:
            id = 8
        case filterset9Button:
            id = 9
        default:
            return
        }
        Debug.print(.event(source: .location(Source()), description: "Filterset \(id) Button Tapped"))
        let filtersetButton = MainViewButton.filterset(displayedFiltersets[id-1], id: id)
        interpreter.userTapped(button: filtersetButton)
    }

//    @IBAction func filtersetButtonLongPressed(_ sender: UIButton) {
//        let id: Int
//        switch sender {
//        case filterset1Button:
//            id = 1
//        case filterset2Button:
//            id = 2
//        case filterset3Button:
//            id = 3
//        case filterset4Button:
//            id = 4
//        case filterset5Button:
//            id = 5
//        case filterset6Button:
//            id = 6
//        case filterset7Button:
//            id = 7
//        case filterset8Button:
//            id = 8
//        case filterset9Button:
//            id = 9
//        default:
//            return
//        }
//        Debug.print(.event(source: .location(Source()), description: "Filterset \(id) Button Long Pressed"))
//        let filtersetButton = MainViewButton.filterset(displayFiltersets[id])
//        interpreter.userLongPressed(button: filtersetButton)
//    }

    @IBAction func providerButtonPressed(_ sender: UIButton) {
        let provider: Provider
        switch sender {
        case driveNowButton:
            provider = .driveNow
        case car2goButton:
            provider = .car2go
        default:
            return
        }
        Debug.print(.event(source: .location(Source()), description: "Provider Button for \(provider.rawValue) Pressed"))
        let providerButton = MainViewButton.provider(provider)
        interpreter.userTapped(button: providerButton)
    }

    @IBAction func mapButtonPressed(_ sender: UIButton) {
        Debug.print(.event(source: .location(Source()), description: "Map Button Pressed"))
        showLoadingAnimation(title: "Finding Vehicles")
        interpreter.userTapped(button: .map)
    }

}

// MARK: - Internal Functions
extension MainViewController: InternalRouting {
    
    fileprivate func setExclusiveTouchForAllButtons() {
        for case let button as UIButton in self.view.subviews {
            button.isExclusiveTouch = true
        }
    }
    
}

// MARK: - Main View Controller Protocol Conformance
extension MainViewController: MainViewControllerProtocol {
    
    // MARK: UI Configuration
    
    func updateFiltersetButtons(filtersets: [Filterset?], providers: [Bool]) {
        // TODO: implement function
    }
    
    // MARK: Segues and Popup Presentation
    
    func presentVehicleMapView(with data: ViewData) {
        // TODO: implement function
        guard let vehicles = data.displayedVehicles else {
            Debug.print(.error(source: .location(Source()), message: "No vehicles received in data!"))
            return
        }
        dismissLoadingAnimation()
        Debug.print(.success(source: .location(Source()), message: "\(vehicles.count) vehicles ready to be displayed."))
    }
    
    func presentLoginPopup() {
        // TODO: implement function
    }
    
    func presentSelectInternalModelOptionsPopup(with data: ViewData) {
        // TODO: implement function
    }
    
    func presentSelectExternalModelOptionsPopup(with data: ViewData) {
        // TODO: implement function
    }
    
    func presentSelectModelsPopup(with data: ViewData) {
        // TODO: implement function
    }
    
    func presentSelectFiltersetIconAndNamePopup(with data: ViewData) {
        // TODO: implement function
    }

}

// MARK: - Popup Delegate Conformance
extension MainViewController: PopupDelegate {

    func popupDismissed(with selectedData: ViewReturnData, via navigationAction: NavigationAction) {
        interpreter.userDismissedPopup(with: selectedData, via: navigationAction)
    }

    func popupWorkflowAborted() {
        interpreter.viewDidAppear()
    }

    func showLoadingAnimation(title: String) {
        let spinner = SwiftSpinner.sharedInstance
        spinner.backgroundColor = UIColor(html: "#010215")
        spinner.innerColor = UIColor(html: "#8fa6c2")
        spinner.outerColor = UIColor(html: "#12253d")
        spinner.titleLabel.textColor = UIColor(html: "#8fa6c2")
        spinner.titleLabel.font = UIFont(name: "Ailerons-Regular", size: 22)
        spinner.title = title
        SwiftSpinner.show(title)
    }

    func dismissLoadingAnimation() {
        SwiftSpinner.hide()
    }

}
