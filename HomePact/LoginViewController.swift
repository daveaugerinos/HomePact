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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
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
}
