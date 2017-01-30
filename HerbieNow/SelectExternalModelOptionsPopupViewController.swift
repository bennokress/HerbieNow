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
