//
//  PopupDelegate.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol PopupDelegate {

    func dismissedLoginPopup(with username: String, and password: String)

    func dismissed(_ popupContent: PopupContent)
    func reverted(_ popupContent: PopupContent)
    func aborted(_ popupContent: PopupContent)

}

extension PopupDelegate {

    internal func dismissedPopup(of type: PopupContent) -> String {
        switch type {
        case .login:
            return "Login Popup dismissed"
        case .modelIntern:
            return "Select Internal Model Options Popup dismissed"
        case .modelExtern:
            return "Select External Model Options Popup dismissed"
        case .modelChoice:
            return "Select Models Popup dismissed"
        case .filtersetDescription:
            return "Select Filterset Name & Icon Popup dismissed"
        }
    }

}
