//
//  SelectExternalModelOptionsPopupViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

protocol SelectExternalModelOptionsPopupViewControllerProtocol: class {

    var interpreter: SelectExternalModelOptionsPopupInterpreterProtocol { get set }
    
    func updateViewData(to newData: ViewData)
    
    func updateSeatsButtonsActiveState(two twoActive: Bool, four fourActive: Bool, five fiveActive: Bool)
    func updateDoorsButtonsActiveState(three threeActive: Bool, five fiveActive: Bool)
    func updateHorsePowerLabelTexts(min minValue: Int, max maxValue: Int)
    func updateFuelLevelLabelTexts(min minValue: Int, max maxValue: Int)

}

// MARK: -
class SelectExternalModelOptionsPopupViewController: PopupViewController {
    
    lazy var interpreter: SelectExternalModelOptionsPopupInterpreterProtocol = SelectExternalModelOptionsPopupInterpreter(for: self) as SelectExternalModelOptionsPopupInterpreterProtocol
    
    // MARK: UI Elements
    
    @IBOutlet fileprivate weak var threeDoorsButton: UIButton!
    @IBOutlet fileprivate weak var fiveDoorsButton: UIButton!

    @IBOutlet fileprivate weak var twoSeatsButton: UIButton!
    @IBOutlet fileprivate weak var fourSeatsButton: UIButton!
    @IBOutlet fileprivate weak var fiveSeatsButton: UIButton!

    @IBOutlet fileprivate weak var nextButton: UIButton!
    @IBOutlet fileprivate weak var backButton: UIButton!
    @IBOutlet fileprivate weak var abortButton: UIButton!
    
    @IBOutlet weak var horsePowerSlider: RangeSlider!
    
    @IBOutlet weak var fuelLevelRangeSlider: RangeSlider!
    
    // MARK: Mandatory View Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        Debug.print(.event(source: .location(Source()), description: "View Did Load"))
        horsePowerSlider.addTarget(self, action: #selector(SelectExternalModelOptionsPopupViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        fuelLevelRangeSlider.addTarget(self, action: #selector(SelectExternalModelOptionsPopupViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
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
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeAction(.back)
        }
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeAction(.abort)
        }
    }
    
    @IBAction func seatsSelectionButtonTapped(_ sender: UIButton) {
        let tappedSeats: Int
        switch sender {
        case twoSeatsButton: tappedSeats = 2
        case fourSeatsButton: tappedSeats = 4
        case fiveSeatsButton: tappedSeats = 5
        default:
            tappedSeats = 0
        }
        interpreter.seatsButtonTapped(for: tappedSeats, with: data)
    }
    
    @IBAction func doorsSelectionButtonTapped(_ sender: UIButton) {
        let tappedDoors: Int
        switch sender {
        case threeDoorsButton: tappedDoors = 3
        case fiveDoorsButton: tappedDoors = 5
        default:
            tappedDoors = 0
        }
        interpreter.doorsButtonTapped(for: tappedDoors, with: data)
    }
    
}

// MARK: - Select External Model Options Popup View Controller Protocol Conformance
extension SelectExternalModelOptionsPopupViewController: SelectExternalModelOptionsPopupViewControllerProtocol {
    
    func updateViewData(to newData: ViewData) {
        data = newData
    }
    
    func updateSeatsButtonsActiveState(two twoActive: Bool, four fourActive: Bool, five fiveActive: Bool) {
        changeButtonState(toActive: twoActive, imageIdentifier: "seats2", button: twoSeatsButton)
        changeButtonState(toActive: fourActive, imageIdentifier: "seats4", button: fourSeatsButton)
        changeButtonState(toActive: fiveActive, imageIdentifier: "seats5", button: fiveSeatsButton)
    }
    
    func updateDoorsButtonsActiveState(three threeActive: Bool, five fiveActive: Bool) {
        changeButtonState(toActive: threeActive, imageIdentifier: "doors3", button: threeDoorsButton)
        changeButtonState(toActive: fiveActive, imageIdentifier: "doors5", button: fiveDoorsButton)
    }
    
    func updateHorsePowerLabelTexts(min minValue: Int, max maxValue: Int) {
        // TODO: Add Value Label
        Debug.print(.info(source: .location(Source()), message: "Update Horse Power Label Texts to: \"\(minValue)\" and \"\(maxValue)\""))
    }
    
    func updateFuelLevelLabelTexts(min minValue: Int, max maxValue: Int) {
        // TODO: Add Value Label
        Debug.print(.info(source: .location(Source()), message: "Update Fuel Level Label Texts to: \"\(minValue)\" and \"\(maxValue)\""))
    }
    
    
}

// MARK: - Internal Functions
extension SelectExternalModelOptionsPopupViewController: InternalRouting {
    
    fileprivate func executeAction(_ action: NavigationAction) {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.externalModelOptionsPopupReturnData(filtersetConfiguration: filtersetConfiguration)
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

// MARK: - Range Slider Delegate
extension SelectExternalModelOptionsPopupViewController: RangeSliderDelegate {
    
    func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        let selectedMinimum = rangeSlider.lowerValue
        let selectedMaximum = rangeSlider.upperValue
        if rangeSlider == horsePowerSlider {
            interpreter.horsePowerSliderChanged(min: selectedMinimum, max: selectedMaximum, with: data)
        } else if rangeSlider == fuelLevelRangeSlider {
            interpreter.fuelLevelSliderChanged(min: selectedMinimum, max: selectedMaximum, with: data)
        }
    }
    
}
