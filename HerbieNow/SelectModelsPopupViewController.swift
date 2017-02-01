//
//  SelectModelsPopupViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

protocol SelectModelsPopupViewControllerProtocol: class {

    var interpreter: SelectModelsPopupInterpreterProtocol { get set }
    
    func updateViewData(to newData: ViewData)
    
    func updateModelsButtonsActiveState(mini3door: Bool, mini5door: Bool, miniConvertible: Bool, miniClubman: Bool, miniCountryman: Bool, bmwI3: Bool, bmw1er: Bool, bmwX1: Bool, bmw2erAT: Bool, bmw2erConvertible: Bool, smartForTwo: Bool, smartRoadster: Bool, smartForFour: Bool, mercedesGLA: Bool, mercedesCLA: Bool, mercedesA: Bool, mercedesB: Bool)

}

// MARK: -
class SelectModelsPopupViewController: PopupViewController {
    
    lazy var interpreter: SelectModelsPopupInterpreterProtocol = SelectModelsPopupInterpreter(for: self) as SelectModelsPopupInterpreterProtocol
    
    // MARK: UI Elements

    @IBOutlet fileprivate weak var bmw1er5DoorButton: UIButton!
    @IBOutlet fileprivate weak var bmwI3Button: UIButton!
    @IBOutlet fileprivate weak var bmwX1Button: UIButton!
    @IBOutlet fileprivate weak var bmw2erATButton: UIButton!
    @IBOutlet fileprivate weak var bmw2erConvertibleButton: UIButton!
    @IBOutlet fileprivate weak var mini3DoorButton: UIButton!
    @IBOutlet fileprivate weak var mini5DoorButton: UIButton!
    @IBOutlet fileprivate weak var miniClubmanButton: UIButton!
    @IBOutlet fileprivate weak var miniConvertibleButton: UIButton!
    @IBOutlet fileprivate weak var smartForTwoButton: UIButton!
    @IBOutlet fileprivate weak var mercedesCLAButton: UIButton!
    @IBOutlet fileprivate weak var mercedesGLAButton: UIButton!
    @IBOutlet fileprivate weak var mercedesAclassButton: UIButton!
    @IBOutlet fileprivate weak var mercedesBclassButton: UIButton!
    
    @IBOutlet fileprivate weak var bmw1er5DoorLabel: UILabel!
    @IBOutlet fileprivate weak var bmwI3Label: UILabel!
    @IBOutlet fileprivate weak var bmwX1Label: UILabel!
    @IBOutlet fileprivate weak var bmw2erATLabel: UILabel!
    @IBOutlet fileprivate weak var bmw2erConvertibleLabel: UILabel!
    @IBOutlet fileprivate weak var mini3DoorLabel: UILabel!
    @IBOutlet fileprivate weak var mini5DoorLabel: UILabel!
    @IBOutlet fileprivate weak var miniClubmanLabel: UILabel!
    @IBOutlet fileprivate weak var miniConvertibleLabel: UILabel!
    @IBOutlet fileprivate weak var smartForTwoLabel: UILabel!
    @IBOutlet fileprivate weak var mercedesCLALabel: UILabel!
    @IBOutlet fileprivate weak var mercedesGLALabel: UILabel!
    @IBOutlet fileprivate weak var mercedesAclassLabel: UILabel!
    @IBOutlet fileprivate weak var mercedesBclassLabel: UILabel!

    @IBOutlet fileprivate weak var nextButton: UIButton!
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
    
    @IBAction func modelSelectionButtonTapped(_ sender: UIButton) {
        let tappedModel: Model
        switch sender {
        case bmw1er5DoorButton: tappedModel = .bmw1er5Door
        case bmwI3Button: tappedModel = .bmwI3
        case bmwX1Button: tappedModel = .bmwX1
        case bmw2erATButton: tappedModel = .bmw2erAT
        case bmw2erConvertibleButton: tappedModel = .bmw2erConvertible
        case mini3DoorButton: tappedModel = .mini3Door
        case mini5DoorButton: tappedModel = .mini5Door
        case miniClubmanButton: tappedModel = .miniClubman
        case miniConvertibleButton: tappedModel = .miniConvertible
        case smartForTwoButton: tappedModel = .smartForTwo
        case mercedesCLAButton: tappedModel = .mercedesCLA
        case mercedesGLAButton: tappedModel = .mercedesGLA
        case mercedesAclassButton: tappedModel = .mercedesAclass
        case mercedesBclassButton: tappedModel = .mercedesBclass
        default:
            tappedModel = .unknown
        }
        interpreter.modelButtonTapped(for: tappedModel, with: data)
    }
    
}

extension SelectModelsPopupViewController: SelectModelsPopupViewControllerProtocol {
    
    func updateViewData(to newData: ViewData) {
        data = newData
    }
    
    func updateModelsButtonsActiveState(mini3door: Bool, mini5door: Bool, miniConvertible: Bool, miniClubman: Bool, miniCountryman: Bool, bmwI3: Bool, bmw1er: Bool, bmwX1: Bool, bmw2erAT: Bool, bmw2erConvertible: Bool, smartForTwo: Bool, smartRoadster: Bool, smartForFour: Bool, mercedesGLA: Bool, mercedesCLA: Bool, mercedesA: Bool, mercedesB: Bool) {
        changeButtonState(toActive: mini3door, button: mini3DoorButton, label: mini3DoorLabel)
        changeButtonState(toActive: mini5door, button: mini5DoorButton, label: mini5DoorLabel)
        changeButtonState(toActive: miniConvertible, button: miniConvertibleButton, label: miniConvertibleLabel)
        changeButtonState(toActive: miniClubman, button: miniClubmanButton, label: miniClubmanLabel)
//        changeButtonState(toActive: miniCountryman, button: miniCountrymanButton, label: miniCountrymanLabel)
        changeButtonState(toActive: bmwI3, button: bmwI3Button, label: bmwI3Label)
        changeButtonState(toActive: bmw1er, button: bmw1er5DoorButton, label: bmw1er5DoorLabel)
        changeButtonState(toActive: bmwX1, button: bmwX1Button, label: bmwX1Label)
        changeButtonState(toActive: bmw2erAT, button: bmw2erATButton, label: bmw2erATLabel)
        changeButtonState(toActive: bmw2erConvertible, button: bmw2erConvertibleButton, label: bmw2erConvertibleLabel)
        changeButtonState(toActive: smartForTwo, button: smartForTwoButton, label: smartForTwoLabel)
        //        changeButtonState(toActive: smartRoadster, button: smartRoadsterButton, label: smartRoadsterLabel)
//        changeButtonState(toActive: smartForFour, button: smartForFourButton, label: smartForFourLabel)
        changeButtonState(toActive: mercedesGLA, button: mercedesGLAButton, label: mercedesGLALabel)
        changeButtonState(toActive: mercedesCLA, button: mercedesCLAButton, label: mercedesCLALabel)
        changeButtonState(toActive: mercedesA, button: mercedesAclassButton, label: mercedesAclassLabel)
        changeButtonState(toActive: mercedesB, button: mercedesBclassButton, label: mercedesBclassLabel)
    }
    
}

// MARK: - Internal Functions
extension SelectModelsPopupViewController: InternalRouting {
    
    fileprivate func executeAction(_ action: NavigationAction) {
        guard let data = data, let filtersetConfiguration = data.filterset else {
            Debug.print(.error(source: .location(Source()), message: "View Data could not be read."))
            return
        }
        let returnData = ViewReturnData.modelsPopupReturnData(filtersetConfiguration: filtersetConfiguration)
        delegate?.popupDismissed(with: returnData, via: action)
    }
    
    fileprivate func changeButtonState(toActive active: Bool, button: UIButton, label: UILabel? = nil) {
        active ? (button.tintColor = UIColor.white) : (button.tintColor = UIColor.darkGray)
        if let label = label {
            active ? (label.textColor = UIColor.white) : (label.textColor = UIColor.darkGray)
        }
    }

}
