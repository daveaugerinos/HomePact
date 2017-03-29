//
//  MakeHomeViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class MakeHomeViewController: UIViewController {

    
    
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet weak var sendInviteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         makeButton.layer.borderColor = UIColor.white.cgColor
        sendInviteButton.layer.borderColor = UIColor.white.cgColor
    }

    // MARK: - Action Methods -

    @IBAction func joinButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showJoinHome()
    }
    
    @IBAction func pickHomeImageButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func makeButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func sendInviteButtonTouched(_ sender: UIButton) {
    }
}
