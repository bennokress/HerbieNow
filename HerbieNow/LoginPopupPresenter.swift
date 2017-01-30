//
//  LoginPopupPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol LoginPopupPresenterProtocol: class {

    weak var popup: LoginPopupViewControllerProtocol? { get set }

    func credentialsAccepted(from returnData: ViewReturnData)
    func usernameRejected(because reason: String)
    func passwordRejected(because reason: String)

}

class LoginPopupPresenter {

    weak var popup: LoginPopupViewControllerProtocol? // avoiding a retain cycle with this weak reference

    init(to loginViewController: LoginPopupViewControllerProtocol? = nil) {
        popup = loginViewController
    }

}

extension LoginPopupPresenter: LoginPopupPresenterProtocol {

    func credentialsAccepted(from returnData: ViewReturnData) {
        popup?.usernameAndPasswordAreSaved(from: returnData)
    }

    func usernameRejected(because reason: String) {
        popup?.usernameWasRejected(because: reason)
    }

    func passwordRejected(because reason: String) {
        popup?.passwordWasRejected(because: reason)
    }

}
