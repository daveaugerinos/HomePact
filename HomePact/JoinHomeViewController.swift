//
//  JoinHomeViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class JoinHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods -
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func joinButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func makeAHomeButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showMakeHome()
    }
}
