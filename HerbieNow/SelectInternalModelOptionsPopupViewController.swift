//
//  SelectInternalModelOptionsPopupViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

protocol SelectInternalModelOptionsPopupViewControllerProtocol: class {

    var interpreter: SelectInternalModelOptionsPopupInterpreterProtocol { get set }
    
    func updateViewData(to newData: ViewData)

    func updateFuelTypeButtonsActiveState(diesel dieselActive: Bool, petrol petrolActive: Bool, electric electricActive: Bool)
    func updateTransmissionTypeButtonsActiveState(automatic automaticActive: Bool, manual manualActive: Bool)
    func updateHiFiSystemButtonActiveState(hifiSystemOnly: Bool)
    
}

// MARK: -
class SelectInternalModelOptionsPopupViewController: PopupViewController {
    
    lazy var interpreter: SelectInternalModelOptionsPopupInterpreterProtocol = SelectInternalModelOptionsPopupInterpreter(for: self) as SelectInternalModelOptionsPopupInterpreterProtocol
    
    // MARK: UI Elements
    
    @IBOutlet fileprivate weak var fuelTypePetrolButton: UIButton!
    @IBOutlet fileprivate weak var fuelTypeDieselButton: UIButton!
    @IBOutlet fileprivate weak var fuelTypeElectricButton: UIButton!
    @IBOutlet fileprivate weak var fuelTypePetrolLabel: UILabel!
    @IBOutlet fileprivate weak var fuelTypeDieselLabel: UILabel!
    @IBOutlet fileprivate weak var fuelTypeElectricLabel: UILabel!

    @IBOutlet fileprivate weak var transmissionTypeAutomaticButton: UIButton!
    @IBOutlet fileprivate weak var transmissionTypeManualButton: UIButton!
    @IBOutlet fileprivate weak var transmissionTypeAutomaticLabel: UILabel!
    @IBOutlet fileprivate weak var transmissionTypeManualLabel: UILabel!
    
    @IBOutlet fileprivate weak var hifiSystemOnlyButton: UIButton!

    @IBOutlet fileprivate weak var nextButton: UIButton!
    @IBOutlet fileprivate weak var abortButton: UIButton!
    
    // MARK: Mandatory View Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        Debug.print(.event(source: .location(Source()), description: "View Did Load"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Debug.print(.event(source: .location(Source()), description: "View Did Appear"))
        interpreter.viewDidAppear(with: data)
    }
    
    // MARK: UI Element Interaction Functions
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeAction(.next)
        }
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeAction(.abort)
        }
    }
    
    @IBAction func fuelTypeButtonTapped(_ sender: UIButton) {
        let tappedFuelType: FuelType
        switch sender {
        case fuelTypePetrolButton: tappedFuelType = .petrol
        case fuelTypeDieselButton: tappedFuelType = .diesel
        case fuelTypeElectricButton: tappedFuelType = .electric
        default:
            tappedFuelType = .unknown
        }
        interpreter.fuelTypeButtonTapped(for: tappedFuelType, with: data)
    }
    
    @IBAction func transmissionTypeButtonTapped(_ sender: UIButton) {
        let tappedTransmissionType: TransmissionType
        switch sender {
        case transmissionTypeAutomaticButton: tappedTransmissionType = .automatic
        case transmissionTypeManualButton: tappedTransmissionType = .manual
        default:
            tappedTransmissionType = .unknown
        }
        interpreter.transmissionTypeButtonTapped(for: tappedTransmissionType, with: data)
    }
    
    @IBAction func hifiSystemOnlyButtonTapped(_ sender: UIButton) {
        interpreter.hifiSystemOnlyButtonTapped(with: data)
    }

}

// MARK: - Select Internal Model Options Popup View Controller Protocol Conformance
extension SelectInternalModelOptionsPopupViewController: SelectInternalModelOptionsPopupViewControllerProtocol {
    
    func updateViewData(to newData: ViewData) {
        data = newData
    }
    
    func updateFuelTypeButtonsActiveState(diesel dieselActive: Bool, petrol petrolActive: Bool, electric electricActive: Bool) {
        changeButtonState(toActive: dieselActive, imageIdentifier: "diesel", button: fuelTypeDieselButton, label: fuelTypeDieselLabel)
        changeButtonState(toActive: petrolActive, imageIdentifier: "petrol", button: fuelTypePetrolButton, label: fuelTypePetrolLabel)
        changeButtonState(toActive: electricActive, imageIdentifier: "electric", button: fuelTypeElectricButton, label: fuelTypeElectricLabel)
    }
    
    func updateTransmissionTypeButtonsActiveState(automatic automaticActive: Bool, manual manualActive: Bool) {
        changeButtonState(toActive: automaticActive, imageIdentifier: "automatic", button: transmissionTypeAutomaticButton, label: transmissionTypeAutomaticLabel)
        changeButtonState(toActive: manualActive, imageIdentifier: "manual", button: transmissionTypeManualButton, label: transmissionTypeManualLabel)
    }
    
    func updateHiFiSystemButtonActiveState(hifiSystemOnly: Bool) {
        changeButtonState(toActive: hifiSystemOnly, imageIdentifier: "hifi", button: hifiSystemOnlyButton)
    }
    
}

// MARK: - Internal Functions
extension SelectInternalModelOptionsPopupViewController: InternalRouting {

    fileprivate func executeAction(_ action: NavigationAction) {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.internalModelOptionsPopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: action)
    }
    
    fileprivate func changeButtonState(toActive active: Bool, imageIdentifier: String, button: UIButton, label: UILabel? = nil) {
        guard let activeImage = UIImage(named: "\(imageIdentifier)"), let inactiveImage = UIImage(named: "\(imageIdentifier)Gray") else {
            Debug.print(.error(source: .location(Source()), message: "Could not find the right Filter Icon"))
            return
        }
        active ? button.setImageForAllStates(activeImage) : button.setImageForAllStates(inactiveImage)
        if let label = label {
            active ? (label.textColor = UIColor.white) : (label.textColor = UIColor.darkGray)
        }
    }

}
