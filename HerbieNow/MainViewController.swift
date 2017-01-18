//
//  MainViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol: class {

    // This protocol contains every function, the MainViewPresenter can call.

    /// Performs the segue to Map View. Typically after the search button is pressed.
    func goToMapView(with vehicles: [Vehicle])

    // TODO: Add arguments and documentation comment - FiltersetButtons & ProviderButtons
    func displayConfiguredButtons(filtersets: [Filterset?], providers: [Bool])

    // TODO: Maybe change to filterset ID? Add documentation comment
    func showDeleteFiltersetAlert(for filterset: Filterset)

}

/// ViewControllers have no logic other than what to display
class MainViewController: UIViewController {

    @IBOutlet fileprivate weak var filterset1Button: UIButton!
    @IBOutlet fileprivate weak var filterset2Button: UIButton!
    @IBOutlet fileprivate weak var filterset3Button: UIButton!
    @IBOutlet fileprivate weak var filterset4Button: UIButton!
    @IBOutlet fileprivate weak var filterset5Button: UIButton!
    @IBOutlet fileprivate weak var filterset6Button: UIButton!
    @IBOutlet fileprivate weak var filterset7Button: UIButton!
    @IBOutlet fileprivate weak var filterset8Button: UIButton!
    @IBOutlet fileprivate weak var filterset9Button: UIButton!
    @IBOutlet fileprivate weak var driveNowButton: UIButton!
    @IBOutlet fileprivate weak var car2goButton: UIButton!
    @IBOutlet fileprivate weak var goToMapButton: UIButton!

    // swiftlint:disable:next force_cast
    lazy var interpreter: MainViewInterpreterProtocol = MainViewInterpreter(for: self, appDelegate: UIApplication.shared.delegate as! AppDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Debug.event(message: "View Did Load"))
        setExclusiveTouchForAllButtons()
        interpreter.dasIstNurEineTestfunktionUmMalZeugAusDemModelLaufenZuLassenOhneMuehsamFrameworksInEinenPlaygroundZuImportieren()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(Debug.event(message: "View Did Appear"))
        interpreter.viewDidAppear()
    }

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
        print(Debug.event(message: "Filterset \(id) Button Pressed"))
        interpreter.filtersetButtonPressed(id: id)
    }

    @IBAction func filtersetButtonLongPressed(_ sender: UIButton) {
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
        print(Debug.event(message: "Filterset \(id) Button Long Pressed"))
        interpreter.filtersetButtonLongPressed(id: id)
    }

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
        print(Debug.event(message: "Account Button Pressed"))
        interpreter.providerButtonPressed(for: provider)
    }

    @IBAction func mapButtonPressed(_ sender: UIButton) {
        print(Debug.event(message: "Map Button Pressed"))
        interpreter.mapButtonPressed()
    }

    private func setExclusiveTouchForAllButtons() {
        for uiObject in self.view.subviews {
            if let button = uiObject as? UIButton {
                button.isExclusiveTouch = true
            }
        }
    }

}

extension MainViewController: MainViewControllerProtocol {

    func goToMapView(with vehicles: [Vehicle]) {
        // TODO: implement function
    }

    func displayConfiguredButtons(filtersets: [Filterset?], providers: [Bool]) {
        // TODO: implement function
    }

    func showDeleteFiltersetAlert(for filterset: Filterset) {
        // TODO: implement function
    }

}

extension MainViewController: PopupDelegate {

    func dismissedLoginPopup(with username: String, and password: String) {
        // TODO: Username and Password have to be saved for Drivenow
    }

    func dismissed(_ popupContent: PopupContent) {
        // TODO: Call Interpreter
    }

    func reverted(_ popupContent: PopupContent) {
        // TODO: Call Interpreter
    }

    func aborted(_ popupContent: PopupContent) {
        // TODO: Call Interpreter
    }

}
