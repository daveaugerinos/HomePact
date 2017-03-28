//
//  JoinHomeViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class JoinHomeViewController: UIViewController {

    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var makeAHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        joinButton.layer.borderColor = UIColor.white.cgColor
        makeAHomeButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Action Methods -
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).popToRootVC()
    }
    
    @IBAction func joinButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func makeAHomeButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showMakeHome()
    }
}
