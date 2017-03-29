//
//  RegisterViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Action Methods -
    
    @IBAction func loginVCButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).popToRootVC()
    }

    @IBAction func pickYourImageButtonTouched(_ sender: UIButton) {
    }

    @IBAction func clearTextPasswordButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func registerButtonTouched(_ sender: UIButton) {
        
        // test setup
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("Error \(error)")
                return
            } else {
                print("Login successful")
                
                if let user = user {
                    let uid = user.uid  // Unique ID, which you can use to identify the user on the client side
                    let email = user.email
                    
                    // let photoURL = user.photoURL
                    
                    print("UID: \(uid)")
                    print("Email: \(email)")
                    
                    user.getTokenWithCompletion({ (token, error) in
                        let idToken = token  // ID token, which you can safely send to a backend
                        print("Token: \(idToken)")
                    })
                }
                return
            }
        })
        
        ViewControllerRouter(self).showJoinHome()
    }
}
