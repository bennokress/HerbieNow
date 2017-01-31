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

}

// MARK: -
class SelectFiltersetIconAndNamePopupViewController: PopupViewController, SelectFiltersetIconAndNamePopupViewControllerProtocol {
    
    lazy var interpreter: SelectFiltersetIconAndNamePopupInterpreterProtocol = SelectFiltersetIconAndNamePopupInterpreter(for: self) as SelectFiltersetIconAndNamePopupInterpreterProtocol
    
    // MARK: Data
    
    var filterset: Filterset = Filterset()
    
    let displayedIcons: [UIImage] = [] // TODO: Fill with actual Icons for AKPickerView
    
    var selectedIconID: Int = 1
    var selectedName = ""
    
    // MARK: UI Elements

    @IBOutlet fileprivate weak var iconPicker: AKPickerView!

    @IBOutlet fileprivate weak var nameTextField: UITextField!

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

    // TODO: Implement AKPickerViewMethods

}

// MARK: - Internal Functions
extension SelectFiltersetIconAndNamePopupViewController: InternalRouting {
    
    fileprivate func setFiltersetName(to newValue: String) {
        selectedName = newValue
    }
    
    // TODO: Add TextFieldDelegate that calls the above method
    
    fileprivate func configureNavigationButtons() {
        DispatchQueue.main.async {
            self.confirmButton.imageForNormal = UIImage(named: "Next")
            self.confirmButton.imageView?.tintColor = UIColor.green
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
        let returnData = ViewReturnData.filtersetIconAndNamePopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: action)
    }
    
}
