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

class SelectInternalModelOptionsPopupViewController: PopupViewController {

    // Displayed Options in Popup
    var displayedFuelTypes: [FuelType] = [.petrol, .diesel, .electric]
    var displayedTransmissionTypes: [TransmissionType] = [.automatic, .manual]
    var displayedHPRange: (min: Int, max: Int) = (0, 200)

    // Selected Values by the user, updated dynamically - Set is used, because it prohibits duplicate items
    var selectedFuelTypes: Set<FuelType> = [.petrol, .diesel, .electric]
    var selectedTransmissionTypes: Set<TransmissionType> = [.automatic, .manual]
    var selectedHPRange: (min: Int, max: Int) = (0, 200)

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

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Debug.event(message: "Select Internal Model Options Popup - View Did Load"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(Debug.event(message: "Select Internal Model Options Popup - View Did Appear"))
        configureNavigationButtons()
    }

    // MARK: - Selection Button Methods

    private func flipSelection(for type: FuelType) {
        if selectedFuelTypes.contains(type) {
            selectedFuelTypes.remove(type)
        } else {
            selectedFuelTypes.insert(type)
        }
    }

    private func flipSelection(for type: TransmissionType) {
        if selectedTransmissionTypes.contains(type) {
            selectedTransmissionTypes.remove(type)
        } else {
            selectedTransmissionTypes.insert(type)
        }
    }

    // TODO: Add generic button function that calls the correct flip based on button ID

    // MARK: - Selection TextField Methods

    private func adjustMinHP(to newValue: Int) {
        selectedHPRange.min = newValue
    }

    private func adjustMaxHP(to newValue: Int) {
        selectedHPRange.max = newValue
    }

    // TODO: Add TextFieldDelegate that calls the above methods

    // MARK: - Navigational Button Methods

    private func configureNavigationButtons() {
        DispatchQueue.main.async {
            self.confirmButton.imageForNormal = UIImage(named: "Next")
            self.confirmButton.imageView?.tintColor = UIColor.green
            self.abortButton.imageForNormal = UIImage(named: "Cancel")
            self.abortButton.imageView?.tintColor = UIColor.blue
            self.backButton.isHidden = true
        }
    }

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

    private func executeConfirmButtonAction() {
        let popup = PopupContent.modelIntern(filterset: filterset)
        delegate?.dismissed(popup)
    }

    private func executeBackButtonAction() {
        let popup = PopupContent.modelIntern(filterset: originalFilterset)
        delegate?.reverted(popup)
    }

    private func executeAbortButtonAction() {
        let popup = PopupContent.modelIntern(filterset: filterset)
        delegate?.aborted(popup)
    }

}
