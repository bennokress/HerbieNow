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
    
}

// MARK: -
class SelectInternalModelOptionsPopupViewController: PopupViewController {
    
    lazy var interpreter: SelectInternalModelOptionsPopupInterpreterProtocol = SelectInternalModelOptionsPopupInterpreter(for: self) as SelectInternalModelOptionsPopupInterpreterProtocol
    
    // MARK: UI Elements
    
    @IBOutlet fileprivate weak var fuelTypePetrolButton: UIButton!
    @IBOutlet fileprivate weak var fuelTypeDieselButton: UIButton!
    @IBOutlet fileprivate weak var fuelTypeElectricButton: UIButton!

    @IBOutlet fileprivate weak var transmissionTypeAutomaticButton: UIButton!
    @IBOutlet fileprivate weak var transmissionTypeManualButton: UIButton!
    
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
            self.executeNextButtonAction()
        }
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeAbortButtonAction()
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
        // TODO: De-Comment when Icons are ready
//        dieselActive ? fuelTypeDieselButton.setImageForAllStates(UIImage(named: "dieselColored")!) : fuelTypeDieselButton.setImageForAllStates(UIImage(named: "dieselGray")!)
//        petrolActive ? fuelTypePetrolButton.setImageForAllStates(UIImage(named: "petrolColored")!) : fuelTypePetrolButton.setImageForAllStates(UIImage(named: "petrolGray")!)
//        electricActive ? fuelTypeElectricButton.setImageForAllStates(UIImage(named: "electricColored")!) : fuelTypeElectricButton.setImageForAllStates(UIImage(named: "electircGray")!)
    }
    
    func updateTransmissionTypeButtonsActiveState(automatic automaticActive: Bool, manual manualActive: Bool) {
        // TODO: De-Comment when Icons are ready
//        automaticActive ? transmissionTypeAutomaticButton.setImageForAllStates(UIImage(named: "automaticColored")!) : transmissionTypeAutomaticButton.setImageForAllStates(UIImage(named: "automaticGray")!)
//        manualActive ? transmissionTypeManualButton.setImageForAllStates(UIImage(named: "manualColored")!) : transmissionTypeManualButton.setImageForAllStates(UIImage(named: "manualGray")!)
    }
    
}

// MARK: - Internal Functions
extension SelectInternalModelOptionsPopupViewController: InternalRouting {

    fileprivate func configureNavigationButtons() {
        DispatchQueue.main.async {
            self.nextButton.imageForNormal = UIImage(named: "Next")
            self.nextButton.imageView?.tintColor = UIColor.green
            self.abortButton.imageForNormal = UIImage(named: "Cancel")
            self.abortButton.imageView?.tintColor = UIColor.blue
        }
    }

    fileprivate func executeNextButtonAction() {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.internalModelOptionsPopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: .next)
    }

    fileprivate func executeBackButtonAction() {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.internalModelOptionsPopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: .back)
    }

    fileprivate func executeAbortButtonAction() {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.internalModelOptionsPopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: .abort)
    }

}

// TODO: Add TextFieldDelegate that calls hpTextfieldValuesChanged
