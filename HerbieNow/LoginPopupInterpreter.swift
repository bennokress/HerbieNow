//
//  LoginPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol LoginPopupInterpreterProtocol: class {
    
    var presenter: LoginPopupPresenterProtocol { get set }
    var logic: LogicProtocol { get set }
    
    func login(with returnData: ViewReturnData)
    
}

class LoginPopupInterpreter {
    
    var presenter: LoginPopupPresenterProtocol
    var logic: LogicProtocol
    
    init(for loginVC: LoginPopupViewControllerProtocol? = nil, _ presenter: LoginPopupPresenterProtocol = LoginPopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {
        self.presenter = LoginPopupPresenter(to: loginVC)
        self.logic = Logic()
    }
    
}

extension LoginPopupInterpreter: LoginPopupInterpreterProtocol {
    
    func login(with returnData: ViewReturnData) {
        
        guard case .loginPopupReturnData(let username, let password) = returnData else {
            Debug.print(.error(source: .location(Source()), message: "Return Data has wrong format."))
            return
        }
        
        guard let usernameString = username, usernameString != "" else {
            presenter.usernameRejected(because: "Username was not accepted.")
            return
        }
        
        guard let passwordString = password, passwordString != "" else {
            presenter.passwordRejected(because: "Password was not accepted.")
            return
        }
        
        logic.save(username: usernameString, password: passwordString)
        presenter.credentialsAccepted(from: returnData)
        
    }
    
}
