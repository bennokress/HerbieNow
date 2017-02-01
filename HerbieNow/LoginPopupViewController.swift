//
//  LoginPopupViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

protocol LoginPopupViewControllerProtocol: class {

    var interpreter: LoginPopupInterpreterProtocol { get set }

    func dismissPopup(with returnData: ViewReturnData)
    func usernameWasRejected(because reason: String)
    func passwordWasRejected(because reason: String)

}

// MARK: -
class LoginPopupViewController: PopupViewController {

    lazy var interpreter: LoginPopupInterpreterProtocol = LoginPopupInterpreter(for: self) as LoginPopupInterpreterProtocol    
    
    // MARK: UI Elements

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Mandatory View Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        Debug.print(.event(source: .view(.login), description: "View Did Load"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Debug.print(.event(source: .view(.login), description: "View Did Appear"))
        configureTextFields()
        configureButtons()
        dismissLoadingAnimation()
    }
    
    // MARK: UI Element Interaction Functions

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }

}

// MARK: - Login Popup View Controller Protocol Conformance
extension LoginPopupViewController: LoginPopupViewControllerProtocol {

    func dismissPopup(with returnData: ViewReturnData) {
        dismiss(animated: true) { () in
            self.delegate?.popupDismissed(with: returnData, via: .confirm)
        }
    }

    func usernameWasRejected(because reason: String) {
        createAlert(title: "Invalid Username", message: reason, buttonText: "OK") { _ in
            self.usernameTextField.clear()
            self.usernameTextField.becomeFirstResponder()
        }
    }

    func passwordWasRejected(because reason: String) {
        createAlert(title: "Invalid Password", message: reason, buttonText: "OK") { _ in
            self.passwordTextField.clear()
            self.passwordTextField.becomeFirstResponder()
        }
    }

}

// MARK: - Internal Functions
extension LoginPopupViewController: InternalRouting {

    fileprivate func configureTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.becomeFirstResponder()
    }

    fileprivate func configureButtons() {
        DispatchQueue.main.async {
            //            self.confirmButton.setImageForAllStates(NavigationAction.confirm.icon)
            self.loginButton.imageView?.tintColor = UIColor.green
        }
    }

    fileprivate func login() {
        interpreter.login(with: gatherReturnData())
    }

    fileprivate func createAlert(title: String, message: String, buttonText: String, onUIAlertAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: { (_) in
            onUIAlertAction()
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func gatherReturnData() -> ViewReturnData {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return ViewReturnData.loginPopupReturnData(username: usernameTextField.text, password: passwordTextField.text)
    }

}

// MARK: - UI Textfield Delegate Conformance
extension LoginPopupViewController: UITextFieldDelegate {

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            self.login()
        default:
            break
        }
        return true
    }

}
