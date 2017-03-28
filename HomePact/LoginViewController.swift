//
//  LoginViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true
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
}
