//
//  ViewController.swift
//  Dardsh
//
//  Created by Abanoub Ashraf on 25/09/2022.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: - IBActions

    @IBAction func forgotPasswordButtonClicked(_ sender: UIButton) {
        print("forget password button...")
    }
    
    @IBAction func resendEmailButtonClicked(_ sender: UIButton) {
        print("resend email button...")
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        print("register button...")
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        print("login button...")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - Helper Functions

    private func setupViews() {
        [emailLabel, passwordLabel, confirmPasswordLabel].forEach { label in
            label?.text = ""
        }
        
        [emailTextField, passwordTextField, confirmPasswordTextField].forEach { textField in
            textField?.delegate = self
        }
    }

}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLabel.text = emailTextField.hasText ? "Email" : ""
        passwordLabel.text = passwordTextField.hasText ? "Password" : ""
        confirmPasswordLabel.text = confirmPasswordTextField.hasText ? "Confirm Password" : ""
    }
    
}
