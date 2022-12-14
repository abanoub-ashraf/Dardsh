//
//  ViewController.swift
//  Dardsh
//
//  Created by Abanoub Ashraf on 25/09/2022.
//

import UIKit
import ProgressHUD

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
        if isDataInputedFor(mode: "forgetPassword") {
            forgetPassword()
        } else {
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    @IBAction func resendEmailButtonClicked(_ sender: UIButton) {
        resendVerificationEmail()
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if isDataInputedFor(mode: isLogin ? "login" : "register") {
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    ///
    /// for updating the ui when switching between log in and register
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
        
        registerLoginButton.layer.cornerRadius = 8
        
        ///
        /// for adding a gesture to the view to hide the keyboard whenever it's visible
        ///
        setupBackgroundTap()
    }
    
    private func updateUIMode(mode: Bool) {
        ///
        /// if the mode is not register
        ///
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
    
    ///
    /// for validating the user inputs
    ///
    private func isDataInputedFor(mode: String) -> Bool {
        switch mode {
            case "login":
                return emailTextField.text != "" && passwordTextField.text != ""
            case "register":
                return emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
            case "forgetPassword":
                return emailTextField.text != ""
            default:
                return false
        }
    }
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func registerUser() {
        if passwordTextField.text == confirmPasswordTextField.text {
            FUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error == nil {
                    ProgressHUD.showSuccess("Verification email's been sent! please verify your email :)")
                } else {
                    ProgressHUD.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    private func loginUser() {
        FUserListener.shared.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            ///
            /// if no error, check the email verification
            ///
            if error == nil {
                ///
                /// if user's email is verified, then go to the app
                ///
                if isEmailVerified {
                    // TODO: - go to the application
                } else {
                    ///
                    /// if not verified, tell the user to check their email
                    ///
                    ProgressHUD.showError("Please check your email and verify your registeration!")
                }
            } else {
                ///
                /// if there's an error, show it to the user
                ///
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FUserListener.shared.resendVerificationEmailWith(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("Verificatin email is Sent")
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    
    private func forgetPassword() {
        FUserListener.shared.resetPasswordFor(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("Reset Password email has been sent")
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }

}

// MARK: - Selectors

extension LoginViewController {
    
    @objc private func hideKeyboard() {
        view.endEditing(false)
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
