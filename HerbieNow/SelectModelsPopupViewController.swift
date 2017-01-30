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

class SelectModelsPopupViewController: PopupViewController {

    // Displayed Models in Popup
    var displayedModels: [Model] = [.bmw1er5Door, .bmwI3, .bmwX1, .bmw2erAT, .bmw2erConvertible,
                                    .mini3Door, .mini5Door, .miniClubman, .miniConvertible,
                                    .smartForTwo, .mercedesCLA, .mercedesGLA, .mercedesAclass, .mercedesBclass]

    // Sele Options in Popup
    var selectedModels: Set<Model> = [.bmw1er5Door, .bmwI3, .bmwX1, .bmw2erAT, .bmw2erConvertible,
                                      .mini3Door, .mini5Door, .miniClubman, .miniConvertible,
                                      .smartForTwo, .mercedesCLA, .mercedesGLA, .mercedesAclass, .mercedesBclass]

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

    @IBOutlet fileprivate weak var confirmButton: UIButton!
    @IBOutlet fileprivate weak var backButton: UIButton!
    @IBOutlet fileprivate weak var abortButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        Debug.print(.event(source: .location(Source()), description: "View Did Load"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Debug.print(.event(source: .location(Source()), description: "View Did Appear"))
        configureNavigationButtons()
    }

    // MARK: - Selection Button Methods

    private func flipModelSelection(for type: Model) {
        if selectedModels.contains(type) {
            selectedModels.remove(type)
        } else {
            selectedModels.insert(type)
        }
    }

    // TODO: Add generic button function that calls the correct flip based on button ID

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
        //        let popup = PopupContent.modelIntern(filterset: Filterset)
        //        delegate?.dismissed(popup)
    }

    private func executeBackButtonAction() {
        //        let popup = PopupContent.modelIntern(filterset: originalFilterset)
        //        delegate?.reverted(popup)
    }

    private func executeAbortButtonAction() {
        //        let popup = PopupContent.modelIntern(filterset: filterset)
        //        delegate?.aborted(popup)
    }

}
