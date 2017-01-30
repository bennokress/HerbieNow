//
//  PopupViewController.swift
//  it-e TimeTrack
//
//  Created by Benno Kress on 18.01.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

class PopupViewController: UIViewController {

    var data: ViewData?
    var delegate: PopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showLoadingAnimation(title: "Loading Data")
    }

    func showLoadingAnimation(title: String) {
        delegate?.showLoadingAnimation(title: title)
    }

    func dismissLoadingAnimation() {
        delegate?.dismissLoadingAnimation()
    }

}

extension PopupViewController: PresentrDelegate {

    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        delegate?.popupWorkflowAborted()
        return true
    }

}
