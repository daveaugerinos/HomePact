//
//  LoginViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true
        
        //GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    deinit {
        if let handle = handle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user != nil {
                // Go to proper VC...
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    // MARK: - Action Methods -
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        
        guard let email = usernameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        // Check for username and password
        if(email == "") {
            alert(title: "Username Required", message: "Please enter your username (the email address used for this account).")
        }
        else if(password == "") {
            alert(title: "Password Required", message: "Please enter your password.")
        }
            
        else {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in

                if(error != nil) {
                    if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                        switch errorCode {
                        case .errorCodeNetworkError:
                            self.alert(title: "Login Error", message: "A network error occurred.")
                        case .errorCodeUserNotFound:
                            self.alert(title: "Login Error", message: "The user account was not found.")
                        case .errorCodeOperationNotAllowed:
                            self.alert(title: "Login Error", message: "Username and password account not currently enabled.")
                        case .errorCodeInvalidEmail:
                            self.alert(title: "Login Error", message: "The email address improperly formed.")
                        case .errorCodeUserDisabled:
                            self.alert(title: "Login Error", message: "The user's account is disabled.")
                        case .errorCodeWrongPassword:
                            self.alert(title: "Login Error", message: "Attempted sign in with a wrong password.")
                        default:
                            self.alert(title: "Login Error", message: "An unusal error has occurred. Please contact support.")
                        }
                    }
                }
                
                else {
                    print("User: \(user)")
                }
            }
        }
    }

    @IBAction func forgotPasswordButtonTouched(_ sender: UIButton) {
    }

    @IBAction func googleButtonTouched(_ sender: UIButton) {
    }

    @IBAction func facebookButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func twitterButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func registerButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showRegister()
    }
    
    // MARK: - Google SignInDelegate Methods -
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Error \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                print("Error \(error)")
                return
            }
            // ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
