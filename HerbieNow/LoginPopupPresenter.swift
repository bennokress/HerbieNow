//
//  LoginPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol LoginPopupPresenterProtocol: class {

    func credentialsAccepted(from returnData: ViewReturnData)
    func usernameRejected(because reason: String)
    func passwordRejected(because reason: String)

}


// MARK: -
class LoginPopupPresenter {
    
    // MARK: Links

    weak var popup: LoginPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    // MARK: Initialization
    
    init(to loginViewController: LoginPopupViewControllerProtocol? = nil) {
        popup = loginViewController
    }

}

// MARK: Login Popup Presenter Protocol Conformance
extension LoginPopupPresenter: LoginPopupPresenterProtocol {

    func credentialsAccepted(from returnData: ViewReturnData) {
        popup?.dismissPopup(with: returnData)
    }

    func usernameRejected(because reason: String) {
        popup?.usernameWasRejected(because: reason)
    }

    func passwordRejected(because reason: String) {
        popup?.passwordWasRejected(because: reason)
    }

}
