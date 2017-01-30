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

}

// MARK: -
class SelectInternalModelOptionsPopupViewController: PopupViewController, SelectInternalModelOptionsPopupViewControllerProtocol {
    
    lazy var interpreter: SelectInternalModelOptionsPopupInterpreterProtocol = SelectInternalModelOptionsPopupInterpreter(for: self) as SelectInternalModelOptionsPopupInterpreterProtocol
    
    // MARK: Data
    
    var filterset: Filterset = Filterset()
    
    var displayedFuelTypes: [FuelType] = [.petrol, .diesel, .electric]
    var displayedTransmissionTypes: [TransmissionType] = [.automatic, .manual]
    var displayedHPRange: (min: Int, max: Int) = (0, 200)
    
    var selectedFuelTypes: Set<FuelType> = [.petrol, .diesel, .electric]
    var selectedTransmissionTypes: Set<TransmissionType> = [.automatic, .manual]
    var selectedHPRange: (min: Int, max: Int) = (0, 200)
    
    // MARK: UI Elements
    
    @IBOutlet fileprivate weak var fuelTypePetrolButton: UIButton!
    @IBOutlet fileprivate weak var fuelTypeDieselButton: UIButton!
    @IBOutlet fileprivate weak var fuelTypeElectricButton: UIButton!

    @IBOutlet fileprivate weak var transmissionTypeAutomaticButton: UIButton!
    @IBOutlet fileprivate weak var transmissionTypeManualButton: UIButton!

    @IBOutlet fileprivate weak var hpMinTextField: UITextField!
    @IBOutlet fileprivate weak var hpMaxTextField: UITextField!

    @IBOutlet fileprivate weak var confirmButton: UIButton!
    @IBOutlet fileprivate weak var backButton: UIButton!
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
    
    @IBAction func confirmBookingButtonTapped(_ sender: Any) {
        dismiss(animated: true) { _ in
            self.executeConfirmButtonAction()
        }
    }
    
    @IBAction func backBookingButtonTapped(_ sender: Any) {
        dismiss(animated: true) { _ in
            self.executeBackButtonAction()
        }
    }
    
    @IBAction func abortButtonTapped(_ sender: Any) {
        dismiss(animated: true) { _ in
            self.executeAbortButtonAction()
        }
    }

}

// MARK: - Internal Functions
extension SelectInternalModelOptionsPopupViewController: InternalRouting {

    fileprivate func flipSelection(for type: FuelType) {
        if selectedFuelTypes.contains(type) {
            selectedFuelTypes.remove(type)
        } else {
            selectedFuelTypes.insert(type)
        }
    }

    fileprivate func flipSelection(for type: TransmissionType) {
        if selectedTransmissionTypes.contains(type) {
            selectedTransmissionTypes.remove(type)
        } else {
            selectedTransmissionTypes.insert(type)
        }
    }

    // TODO: Add generic button function that calls the correct flip based on button ID

    fileprivate func adjustMinHP(to newValue: Int) {
        selectedHPRange.min = newValue
    }

    fileprivate func adjustMaxHP(to newValue: Int) {
        selectedHPRange.max = newValue
    }

    // TODO: Add TextFieldDelegate that calls the above methods

    fileprivate func configureNavigationButtons() {
        DispatchQueue.main.async {
            self.confirmButton.imageForNormal = UIImage(named: "Next")
            self.confirmButton.imageView?.tintColor = UIColor.green
            self.abortButton.imageForNormal = UIImage(named: "Cancel")
            self.abortButton.imageView?.tintColor = UIColor.blue
            self.backButton.isHidden = true
        }
    }

    fileprivate func executeConfirmButtonAction() {
        //        let popup = PopupContent.modelIntern(filterset: filterset)
        //        delegate?.dismissed(popup)
    }

    fileprivate func executeBackButtonAction() {
        //        let popup = PopupContent.modelIntern(filterset: originalFilterset)
        //        delegate?.reverted(popup)
    }

    fileprivate func executeAbortButtonAction() {
        //        let popup = PopupContent.modelIntern(filterset: filterset)
        //        delegate?.aborted(popup)
    }

}
