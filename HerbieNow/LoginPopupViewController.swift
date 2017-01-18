//
//  LoginPopupViewController.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

class LoginPopupViewController: PopupViewController {

    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var confirmButton: UIButton!

    var delegate: PopupDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Debug.event(message: "Login Popup - View Did Load"))
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(Debug.event(message: "Login Popup - View Did Appear"))
        usernameTextField.becomeFirstResponder()
    }

    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        login()
    }

    private func configureButtons() {
        DispatchQueue.main.async {
            self.confirmButton.imageForNormal = UIImage(named: "Confirm")
            self.confirmButton.imageView?.tintColor = UIColor.green
        }
    }

    fileprivate func login() {

        guard let username = usernameTextField.text, username != "" else {
            createAlert(title: "Username missing", message: "Please enter your username.", buttonText: "OK") { () in
                self.usernameTextField.text = ""
                self.usernameTextField.becomeFirstResponder()
            }
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            createAlert(title: "Password missing", message: "Please enter your password.", buttonText: "OK") { () in
                self.passwordTextField.text = ""
                self.passwordTextField.becomeFirstResponder()
            }
            return
        }

        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        dismiss(animated: true) { () in
            self.delegate?.dismissedLoginPopup(with: username, and: password)
        }

    }

    private func createAlert(title: String, message: String, buttonText: String, onUIAlertAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: { (_) in
            onUIAlertAction()
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }

}

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
        return false
    }

}
