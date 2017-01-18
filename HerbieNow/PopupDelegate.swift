//
//  PopupDelegate.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol PopupDelegate {

    // TODO: Username and Password have to be saved for Drivenow
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
            return "Select Model Attributes (intern) Popup dismissed"
        case .modelExtern:
            return "Select Model Attributes (extern) Popup dismissed"
        case .modelChoice:
            return "Select Model Popup dismissed"
        case .filtersetDescription:
            return "Select Name & Icon Popup dismissed"
        }
    }

}
