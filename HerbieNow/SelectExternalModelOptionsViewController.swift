//
//  SelectExternalModelOptionsViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

class SelectExternalModelOptionsViewController: PopupViewController {

    // Sele Options in Popup
    var selectedFuelLevelRange: (min: Int, max: Int) = (0, 100)
    var selectedDoorOptions: [Int : Bool] = [3 : true, 5: true]
    var selectedSeatOptions: [Int : Bool] = [2 : true, 4 : true, 5: true]
    var selectedHiFiMandatorySetting: Bool = false

    // This will be set by the MainViewController, so that the Popup has a way to get information back there
    var delegate: PopupDelegate? = nil

    @IBOutlet fileprivate weak var fuelLevelMinTextField: UITextField!
    @IBOutlet fileprivate weak var fuelLevelMaxTextField: UITextField!

    @IBOutlet fileprivate weak var threeDoorsButton: UIButton!
    @IBOutlet fileprivate weak var fiveDoorsButton: UIButton!

    @IBOutlet fileprivate weak var twoSeatsButton: UIButton!
    @IBOutlet fileprivate weak var fourSeatsButton: UIButton!
    @IBOutlet fileprivate weak var fiveSeatsButton: UIButton!

    @IBOutlet fileprivate weak var hifiOptionButton: UIButton!

    @IBOutlet fileprivate weak var confirmButton: UIButton!
    @IBOutlet fileprivate weak var backButton: UIButton!
    @IBOutlet fileprivate weak var abortButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Debug.event(message: "Select External Model Options Popup - View Did Load"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(Debug.event(message: "Select External Model Options Popup - View Did Appear"))
        configureNavigationButtons()
    }

    // MARK: - Selection Button Methods

    //    private func flipDoorSelection(for type: Doors) {
    //        if selectedDoorTypes.contains(type) {
    //            selectedDoorTypes.remove(type)
    //        } else {
    //            selectedDoorTypes.insert(type)
    //        }
    //    }
    //
    //    private func flipSelection(for type: Seats) {
    //        if selectedSeatTypes.contains(type) {
    //            selectedSeatTypes.remove(type)
    //        } else {
    //            selectedSeatTypes.insert(type)
    //        }
    //    }

    private func flipSelectionForHiFi() {
        selectedHiFiMandatorySetting = !selectedHiFiMandatorySetting
    }

    // TODO: Add generic button function that calls the correct flip based on button ID

    // MARK: - Selection TextField Methods

    private func adjustMinFuelLevel(to newValue: Int) {
        selectedFuelLevelRange.min = newValue
    }

    private func adjustMaxFuelLevel(to newValue: Int) {
        selectedFuelLevelRange.max = newValue
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
