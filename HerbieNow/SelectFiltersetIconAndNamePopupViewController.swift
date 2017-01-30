//
//  SelectFiltersetIconAndNamePopupViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

class SelectFiltersetIconAndNamePopupViewController: PopupViewController {

    let displayedIcons: [UIImage] = [] // TODO: Fill with actual Icons for AKPickerView

    var selectedIconID: Int = 1
    var selectedName = ""

    // This will be set by the MainViewController, so that the Popup has a way to get information back there
    var delegate: PopupDelegate?

    @IBOutlet fileprivate weak var iconPicker: AKPickerView!

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
        // TODO: Remove models based on current filterset from displayed models to disable them permanently for the current workflow
        configureNavigationButtons()
    }

    // MARK: - Icon Picker Methods

    // TODO: Implement AKPickerViewMethods

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
