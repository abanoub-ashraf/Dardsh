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
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var registerLoginButton: UIButton!
    @IBOutlet weak var bottomLoginButton: UIButton!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    
    // MARK: - Variables

    var isLogin: Bool = false
    
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
    
    ///
    /// <# Comment #>
    ///
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        updateUIMode(mode: isLogin)
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - Helper Functions

    private func setupViews() {
        ///
        /// start these labels as empty and only fill them with text when the user starts typing in the textField
        ///
        [emailLabel, passwordLabel, confirmPasswordLabel].forEach { label in
            label?.text = ""
        }
        
        [emailTextField, passwordTextField, confirmPasswordTextField].forEach { textField in
            textField?.delegate = self
        }
        
        forgetPasswordButton.isHidden = true
    }
    
    private func updateUIMode(mode: Bool) {
        // if the mode is not register
        if !mode {
            titleLabel.text = "Login"
            confirmPasswordLabel.isHidden = true
            confirmPasswordTextField.isHidden = true
            registerLoginButton.setTitle("Login", for: .normal)
            bottomLoginButton.setTitle("Register", for: .normal)
            haveAnAccountLabel.text = "New here?"
            resendEmailButton.isHidden = true
            forgetPasswordButton.isHidden = false
        } else {
            titleLabel.text = "Register"
            confirmPasswordLabel.isHidden = false
            confirmPasswordTextField.isHidden = false
            registerLoginButton.setTitle("Register", for: .normal)
            bottomLoginButton.setTitle("Login", for: .normal)
            haveAnAccountLabel.text = "Have an Account?"
            resendEmailButton.isHidden = false
            forgetPasswordButton.isHidden = true
        }
        
        isLogin.toggle()
    }

}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    ///
    /// update the labels with text when the user starts typing in these textFields
    ///
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLabel.text = emailTextField.hasText ? "Email" : ""
        passwordLabel.text = passwordTextField.hasText ? "Password" : ""
        confirmPasswordLabel.text = confirmPasswordTextField.hasText ? "Confirm Password" : ""
    }
    
}
