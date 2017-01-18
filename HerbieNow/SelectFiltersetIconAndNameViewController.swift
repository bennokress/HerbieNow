//
//  SelectFiltersetIconAndNameViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

class SelectFiltersetIconAndNameViewController: PopupViewController {

    var selectedIconID: Int = 1
    var selectedName = ""

    // This will be set by the MainViewController, so that the Popup has a way to get information back there
    var delegate: PopupDelegate? = nil

    @IBOutlet fileprivate weak var icon01Button: UIButton!
    @IBOutlet fileprivate weak var icon02Button: UIButton!
    @IBOutlet fileprivate weak var icon03Button: UIButton!
    @IBOutlet fileprivate weak var icon04Button: UIButton!
    @IBOutlet fileprivate weak var icon05Button: UIButton!
    @IBOutlet fileprivate weak var icon06Button: UIButton!
    @IBOutlet fileprivate weak var icon07Button: UIButton!
    @IBOutlet fileprivate weak var icon08Button: UIButton!
    @IBOutlet fileprivate weak var icon09Button: UIButton!
    @IBOutlet fileprivate weak var icon10Button: UIButton!
    @IBOutlet fileprivate weak var icon11Button: UIButton!
    @IBOutlet fileprivate weak var icon12Button: UIButton!
    
    @IBOutlet fileprivate weak var nameTextField: UITextField!

    @IBOutlet fileprivate weak var confirmButton: UIButton!
    @IBOutlet fileprivate weak var backButton: UIButton!
    @IBOutlet fileprivate weak var abortButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Debug.event(message: "Select Filterset Name & Icon Popup - View Did Load"))
        selectedName = "Filterset #\(filterset.getPosition())"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(Debug.event(message: "Select Filterset Name & Icon Popup - View Did Appear"))
        configureNavigationButtons()
    }

    // MARK: - Selection Button Methods

    private func changeIconSelection(to iconID: Int) {
        selectedIconID = iconID
    }

    // TODO: Add generic button function that calls the correct selection and deselects all other buttons based on button ID (icon = buttonID+1)
    
    // MARK: - Selection TextField Methods
    
    private func setFiltersetName(to newValue: String) {
        selectedName = newValue
    }
    
    // TODO: Add TextFieldDelegate that calls the above method
    
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
