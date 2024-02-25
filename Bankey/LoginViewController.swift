//
//  ViewController.swift
//  Bankey
//
//  Created by Abdusamad Mamasoliyev on 24/02/24.
//

import UIKit

class LoginViewController: UIViewController {

    let loginView = LoginView()
    let singInButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    
    var username: String? {
        return loginView.usermameTextField.text
    }
    
    var password: String? {
        return loginView.passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}
extension LoginViewController {
    private func style() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        singInButton.translatesAutoresizingMaskIntoConstraints = false
        singInButton.configuration = .filled()
        singInButton.configuration?.imagePadding = 8
        singInButton.setTitle("Sing In", for: [])
        singInButton.addTarget(self, action: #selector(singInTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
    }
    private func layout() {
        view.addSubview(loginView)
        view.addSubview(singInButton)
        view.addSubview(errorMessageLabel)
        
        // LoginView
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1)
        ])
        
        // Button
        NSLayoutConstraint.activate([
            singInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 3),
            singInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            singInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        // Error Label
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: singInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
    }
}
// MARK: Action
extension LoginViewController {
    @objc func singInTapped(sender: UIButton) {
        
        errorMessageLabel.isHidden = true
        login()
    }
    
    private func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username / password should never be nil")
            return
        }
        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "Username / password cannot be blank ")
        }
        if username == "Idevfan" && password == "12345678" {
            singInButton.configuration?.showsActivityIndicator = true
        } else {
            configureView(withMessage: "Incorrect username / password")
        }
    }
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}

