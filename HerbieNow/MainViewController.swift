//
//  MainViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import SwiftSpinner
import Presentr
import MapKit

protocol MainViewControllerProtocol: class {

    // MARK: UI Configuration
    func updateFiltersetButtons(filtersets: [Filterset?])
    func updateProviderButtons(driveNow driveNowActive: Bool, car2go car2goActive: Bool)
    func dismissLoadingAnimation()
    
    // MARK: Segues and Popup Presentation
    func presentVehicleMapView(with data: ViewData)
    func presentDriveNowLoginPopup()
    func presentSelectInternalModelOptionsPopup(with data: ViewData)
    func presentSelectExternalModelOptionsPopup(with data: ViewData)
    func presentSelectModelsPopup(with data: ViewData)
    func presentSelectFiltersetIconAndNamePopup(with data: ViewData)

}

// MARK: -
class MainViewController: UIViewController, MapViewDelegate {
    
    lazy var interpreter: MainViewInterpreterProtocol = MainViewInterpreter(for: self, appDelegate: UIApplication.shared.delegate as! AppDelegate)
    
    let segueIdentifier = "vehicleMapSegue"
    
    // MARK: Data
    
    var displayedFiltersets: [Filterset?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    var driveNowConfigured: Bool = false
    var car2goConfigured: Bool = false
    
    var vehicleMapData: ViewData = .vehicleMapData(displayedVehicles: [])

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier, let vehicleMapVC = segue.destination as? VehicleMapViewController {
            vehicleMapVC.data = vehicleMapData
            vehicleMapVC.delegate = self
        }
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
        if displayedFiltersets[id-1] != nil { showLoadingAnimation(title: "Finding Vehicles") }
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
        showLoadingAnimation(title: "Finding Vehicles")
        interpreter.userTapped(button: providerButton)
    }

    @IBAction func mapButtonPressed(_ sender: UIButton) {
        Debug.print(.event(source: .location(Source()), description: "Map Button Pressed"))
        showLoadingAnimation(title: "Finding Vehicles")
        interpreter.userTapped(button: .map)
    }
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) { }

}

// MARK: - Internal Functions
extension MainViewController: InternalRouting {
    
    fileprivate func setExclusiveTouchForAllButtons() {
        for case let button as UIButton in self.view.subviews {
            button.isExclusiveTouch = true
        }
    }
    
    fileprivate func reloadFiltersetButtons() {
        
        var round = 0
        
        for filterset in displayedFiltersets {
            
            round += 1
            
            var currentButton: UIButton
            var currentLabel: UILabel
            
            switch round {
            case 1:
                currentButton = filterset1Button
                currentLabel = filterset1Label
            case 2:
                currentButton = filterset2Button
                currentLabel = filterset2Label
            case 3:
                currentButton = filterset3Button
                currentLabel = filterset3Label
            case 4:
                currentButton = filterset4Button
                currentLabel = filterset4Label
            case 5:
                currentButton = filterset5Button
                currentLabel = filterset5Label
            case 6:
                currentButton = filterset6Button
                currentLabel = filterset6Label
            case 7:
                currentButton = filterset7Button
                currentLabel = filterset7Label
            case 8:
                currentButton = filterset8Button
                currentLabel = filterset8Label
            case 9:
                currentButton = filterset9Button
                currentLabel = filterset9Label
            default:
                fatalError("Filterset Index out of range!")
            }
            
            if let filterset = filterset {
                
                currentButton.setImageForAllStates(UIImage.from(base64string: filterset.encodedImage))
                currentLabel.text = filterset.name
                
            } else {
                
                currentButton.setImageForAllStates(#imageLiteral(resourceName: "addFilter"))
                currentLabel.text = "Add Filterset"
                
            }
        }
    }
    
    fileprivate func reloadProviderButtons() {
        driveNowConfigured ? driveNowButton.setImageForAllStates(#imageLiteral(resourceName: "driveNow")) : driveNowButton.setImageForAllStates(#imageLiteral(resourceName: "Face11"))
        car2goConfigured ? car2goButton.setImageForAllStates(#imageLiteral(resourceName: "car2go")) : car2goButton.setImageForAllStates(#imageLiteral(resourceName: "Face03"))
        // TODO: Implement greyed out buttons if false
    }
    
    fileprivate func presentPopup(ofType popup: Presentr, viewController: PopupViewController, with data: ViewData? = nil) {
        viewController.data = data
        viewController.delegate = self
        customPresentViewController(popup, viewController: viewController, animated: true, completion: nil)
    }
    
}

// MARK: - Main View Controller Protocol Conformance
extension MainViewController: MainViewControllerProtocol {
    
    // MARK: UI Configuration
    
    func updateFiltersetButtons(filtersets: [Filterset?]) {
        displayedFiltersets = filtersets
        reloadFiltersetButtons()
    }
    
    func updateProviderButtons(driveNow driveNowActive: Bool, car2go car2goActive: Bool) {
        driveNowConfigured = driveNowActive
        car2goConfigured = car2goActive
        reloadProviderButtons()
    }
    
    // MARK: Segues and Popup Presentation
    
    func presentVehicleMapView(with data: ViewData) {
        vehicleMapData = data
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    func presentDriveNowLoginPopup() {
        presentPopup(ofType: popupConfiguration, viewController: loginPopupVC)
    }
    
    func presentSelectInternalModelOptionsPopup(with data: ViewData) {
        presentPopup(ofType: popupConfiguration, viewController: internalModelOptionsPopupVC, with: data)
    }
    
    func presentSelectExternalModelOptionsPopup(with data: ViewData) {
        presentPopup(ofType: popupConfiguration, viewController: externalModalOptionsPopupVC, with: data)
    }
    
    func presentSelectModelsPopup(with data: ViewData) {
        presentPopup(ofType: popupConfiguration, viewController: modelsPopupVC, with: data)
    }
    
    func presentSelectFiltersetIconAndNamePopup(with data: ViewData) {
        presentPopup(ofType: popupConfiguration, viewController: filtersetIconAndNamePopupVC, with: data)
    }

}

// MARK: - Popup Setup
extension MainViewController: PopupSetup {
    
    var popupConfiguration: Presentr {
        let screenHeight = super.view.height
        let screeWidth = super.view.width
        
        let sideAndBottomSpaceToScreen: CGFloat = 27
        let topSpaceToScreen = screenHeight * 0.11 + UIApplication.shared.statusBarFrame.height // Top View is set to 11% of full height in storyboard!
        
        let popupHeight = Float(screenHeight - topSpaceToScreen - sideAndBottomSpaceToScreen)
        let height = ModalSize.custom(size: popupHeight)
        
        let popupWidth = Float(screeWidth - (2 * sideAndBottomSpaceToScreen))
        let width = ModalSize.custom(size: popupWidth)
        
        let originX: CGFloat = sideAndBottomSpaceToScreen
        let originY: CGFloat = topSpaceToScreen
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: originX, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPopup = Presentr(presentationType: customType)
        customPopup.transitionType = .coverVertical // presenting upwards
        customPopup.dismissTransitionType = .coverVerticalFromTop // dismissing downwards
        customPopup.dismissOnTap = true
        customPopup.dismissOnSwipe = false
        customPopup.dismissAnimated = true
        customPopup.roundCorners = false
        customPopup.backgroundOpacity = 0.5
        customPopup.blurBackground = false
        
        return customPopup
    }
    
    var loginPopupVC: LoginPopupViewController {
        return AppStoryboard.main.viewController(LoginPopupViewController.self)
    }
    
    var internalModelOptionsPopupVC: SelectInternalModelOptionsPopupViewController {
        return AppStoryboard.main.viewController(SelectInternalModelOptionsPopupViewController.self)
    }
    
    var externalModalOptionsPopupVC: SelectExternalModelOptionsPopupViewController {
        return AppStoryboard.main.viewController(SelectExternalModelOptionsPopupViewController.self)
    }
    
    var modelsPopupVC: SelectModelsPopupViewController {
        return AppStoryboard.main.viewController(SelectModelsPopupViewController.self)
    }
    
    var filtersetIconAndNamePopupVC: SelectFiltersetIconAndNamePopupViewController {
        return AppStoryboard.main.viewController(SelectFiltersetIconAndNamePopupViewController.self)
    }
    
}

// MARK: - Popup Delegate Conformance
extension MainViewController: PopupDelegate {

    func popupDismissed(with selectedData: ViewReturnData, via navigationAction: NavigationAction) {
        interpreter.userDismissedPopup(with: selectedData, via: navigationAction)
    }

    func popupWorkflowAborted() {
        interpreter.userDismissedPopup(with: .noReturnData, via: .abort)
    }

    func showLoadingAnimation(title: String) {
        DispatchQueue.main.async {
            let spinner = SwiftSpinner.sharedInstance
            spinner.backgroundColor = UIColor(html: "#010215")
            spinner.innerColor = UIColor(html: "#8fa6c2")
            spinner.outerColor = UIColor(html: "#12253d")
            spinner.titleLabel.textColor = UIColor(html: "#8fa6c2")
            spinner.titleLabel.font = UIFont(name: "Ailerons-Regular", size: 22)
            spinner.title = title
            SwiftSpinner.show(title)
        }
    }

    func dismissLoadingAnimation() {
        DispatchQueue.main.async {
            SwiftSpinner.hide()
        }
    }

}
