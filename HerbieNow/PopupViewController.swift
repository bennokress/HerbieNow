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
        setExclusiveTouchForAllButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dismissLoadingAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func showLoadingAnimation(title: String) {
        delegate?.showLoadingAnimation(title: title)
    }

    func dismissLoadingAnimation() {
        delegate?.dismissLoadingAnimation()
    }
    
    private func setExclusiveTouchForAllButtons() {
        for case let button as UIButton in self.view.subviews {
            button.isExclusiveTouch = true
        }
    }

}

extension PopupViewController: PresentrDelegate {

    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        delegate?.popupWorkflowAborted()
        return true
    }

}
