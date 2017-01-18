//
//  PopupViewController.swift
//  it-e TimeTrack
//
//  Created by Benno Kress on 18.01.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import SwiftSpinner
import Presentr

class PopupViewController: UIViewController {
    
    var bookingMode: BookingPopupMode = .unknown
    
    // To display in the Booking Detail Popup
    var booking: Booking = Booking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showLoadingAnimation() {
        SwiftSpinner.setTitleFont(ciFont)
        SwiftSpinner.show("Loading Data")
    }
    
    func dismissLoadingAnimation() {
        SwiftSpinner.hide()
    }
    
}

extension PopupViewController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        print(Debug.warning(source: (name(of: self), #function), message: "presentrShouldDismiss was called ... maybe this is useful to clean up stuff?"))
        return true
    }
    
}
