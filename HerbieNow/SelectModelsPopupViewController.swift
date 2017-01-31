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

}

// MARK: -
class SelectModelsPopupViewController: PopupViewController, SelectModelsPopupViewControllerProtocol {
    
    lazy var interpreter: SelectModelsPopupInterpreterProtocol = SelectModelsPopupInterpreter(for: self) as SelectModelsPopupInterpreterProtocol
    
    // MARK: Data
    
    var filterset: Filterset = Filterset()
    
    // Displayed Models in Popup
    var displayedModels: [Model] = [.bmw1er5Door, .bmwI3, .bmwX1, .bmw2erAT, .bmw2erConvertible,
                                    .mini3Door, .mini5Door, .miniClubman, .miniConvertible,
                                    .smartForTwo, .mercedesCLA, .mercedesGLA, .mercedesAclass, .mercedesBclass]
    
    // Sele Options in Popup
    var selectedModels: Set<Model> = [.bmw1er5Door, .bmwI3, .bmwX1, .bmw2erAT, .bmw2erConvertible,
                                      .mini3Door, .mini5Door, .miniClubman, .miniConvertible,
                                      .smartForTwo, .mercedesCLA, .mercedesGLA, .mercedesAclass, .mercedesBclass]
    
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
            self.executeNextButtonAction()
        }
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeBackButtonAction()
        }
    }

    @IBAction func abortButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { _ in
            self.executeAbortButtonAction()
        }
    }
    
}

// MARK: - Internal Functions
extension SelectModelsPopupViewController {
    
    // TODO: Add generic button function that calls the correct flip based on button ID
    
    fileprivate func configureNavigationButtons() {
        DispatchQueue.main.async {
            self.nextButton.imageForNormal = UIImage(named: "Next")
            self.nextButton.imageView?.tintColor = UIColor.green
            self.abortButton.imageForNormal = UIImage(named: "Cancel")
            self.abortButton.imageView?.tintColor = UIColor.blue
            self.backButton.isHidden = true
        }
    }
    
    fileprivate func flipModelSelection(for type: Model) {
        if selectedModels.contains(type) {
            selectedModels.remove(type)
        } else {
            selectedModels.insert(type)
        }
    }

    fileprivate func executeNextButtonAction() {
        //        let popup = PopupContent.modelIntern(filterset: Filterset)
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
