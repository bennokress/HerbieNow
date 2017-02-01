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

}

// MARK: -
class SelectExternalModelOptionsPopupViewController: PopupViewController, SelectExternalModelOptionsPopupViewControllerProtocol {
    
    lazy var interpreter: SelectExternalModelOptionsPopupInterpreterProtocol = SelectExternalModelOptionsPopupInterpreter(for: self) as SelectExternalModelOptionsPopupInterpreterProtocol
    
    // MARK: Data
    
    var filterset: Filterset = Filterset()
    
    var selectedFuelLevelRange: (min: Int, max: Int) = (0, 100)
    var selectedDoorOptions: [Int : Bool] = [3 : true, 5: true]
    var selectedSeatOptions: [Int : Bool] = [2 : true, 4 : true, 5: true]
    var selectedHiFiMandatorySetting: Bool = false
    
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
    
    }
    
    @IBAction func doorsSelectionButtonTapped(_ sender: UIButton) {
        
    }
    
}

// MARK: - Internal Functions
extension SelectExternalModelOptionsPopupViewController: InternalRouting {

    //    fileprivate func flipDoorSelection(for type: Doors) {
    //        if selectedDoorTypes.contains(type) {
    //            selectedDoorTypes.remove(type)
    //        } else {
    //            selectedDoorTypes.insert(type)
    //        }
    //    }
    //
    //    fileprivate func flipSelection(for type: Seats) {
    //        if selectedSeatTypes.contains(type) {
    //            selectedSeatTypes.remove(type)
    //        } else {
    //            selectedSeatTypes.insert(type)
    //        }
    //    }

    fileprivate func flipSelectionForHiFi() {
        selectedHiFiMandatorySetting = !selectedHiFiMandatorySetting
    }

    // TODO: Add generic button function that calls the correct flip based on button ID

    fileprivate func adjustMinFuelLevel(to newValue: Int) {
        selectedFuelLevelRange.min = newValue
    }

    fileprivate func adjustMaxFuelLevel(to newValue: Int) {
        selectedFuelLevelRange.max = newValue
    }

    // TODO: Add TextFieldDelegate that calls the above methods

    fileprivate func configureNavigationButtons() {
        DispatchQueue.main.async {
            self.nextButton.imageForNormal = UIImage(named: "Next")
            self.nextButton.imageView?.tintColor = UIColor.green
            self.abortButton.imageForNormal = UIImage(named: "Cancel")
            self.abortButton.imageView?.tintColor = UIColor.blue
            self.backButton.isHidden = true
        }
    }
    
    fileprivate func executeAction(_ action: NavigationAction) {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.externalModelOptionsPopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: action)
    }

}

// MARK: - Range Slider Delegate
extension SelectExternalModelOptionsPopupViewController: RangeSliderDelegate {
    
    func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        rangeSlider == horsePowerSlider ? print("HP: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))") : print("Fuel Level: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
    }
    
}
