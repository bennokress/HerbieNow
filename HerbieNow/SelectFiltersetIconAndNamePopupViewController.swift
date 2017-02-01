//
//  SelectFiltersetIconAndNamePopupViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

protocol SelectFiltersetIconAndNamePopupViewControllerProtocol: class {

    var interpreter: SelectFiltersetIconAndNamePopupInterpreterProtocol { get set }
    
    func updateViewData(to newData: ViewData)
    
    func fillPicker(with encodedIcons: [String])
    func updateFiltersetNameTextField(to name: String)

}

// MARK: -
class SelectFiltersetIconAndNamePopupViewController: PopupViewController {
    
    lazy var interpreter: SelectFiltersetIconAndNamePopupInterpreterProtocol = SelectFiltersetIconAndNamePopupInterpreter(for: self) as SelectFiltersetIconAndNamePopupInterpreterProtocol
    
    // MARK: Data
    
    var displayedIcons: [UIImage] = []
    
    // MARK: UI Elements

    @IBOutlet fileprivate weak var iconPicker: AKPickerView!

    @IBOutlet fileprivate weak var nameTextField: UITextField!

    @IBOutlet fileprivate weak var confirmButton: UIButton!
    @IBOutlet fileprivate weak var backButton: UIButton!
    @IBOutlet fileprivate weak var abortButton: UIButton!
    
    // MARK: Mandatory View Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        iconPicker.delegate = self
        iconPicker.dataSource = self
        Debug.print(.event(source: .location(Source()), description: "View Did Load"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Debug.print(.event(source: .location(Source()), description: "View Did Appear"))
        interpreter.viewDidAppear(with: data)
    }
    
    // MARK: UI Element Interaction Functions
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeAction(.confirm)
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

}

extension SelectFiltersetIconAndNamePopupViewController: SelectFiltersetIconAndNamePopupViewControllerProtocol {
    
    func updateViewData(to newData: ViewData) {
        data = newData
    }
    
    func fillPicker(with encodedIcons: [String]) {
        var icons: [UIImage] = []
        for encodedIcon in encodedIcons {
            icons.append(UIImage.from(base64string: encodedIcon))
        }
        displayedIcons = icons
        iconPicker.reloadData()
    }
    
    func updateFiltersetNameTextField(to name: String) {
        
    }
    
}

// MARK: - Internal Functions
extension SelectFiltersetIconAndNamePopupViewController: InternalRouting {
    
    fileprivate func executeAction(_ action: NavigationAction) {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.filtersetIconAndNamePopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: action)
    }
    
}

// MARK: - AKPickerView DataSource & Delegate Conformance
extension SelectFiltersetIconAndNamePopupViewController: AKPickerViewDataSource, AKPickerViewDelegate {
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return displayedIcons.count
    }
    
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        guard let icon = displayedIcons[item].filled(withColor: .white).scaled(toHeight: pickerView.height) else {
            Debug.print(.error(source: .location(Source()), message: "Could not edit icon for picker."))
            return UIImage()
        }
        return icon
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        interpreter.iconSelected(displayedIcons[item].base64encoded)
    }
    
}

// TODO: Implement UITexfield Methods
