//
//  ProfilesPersonalViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class ProfilesPersonalViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roundAppropriateViews()
        self.view.backgroundColor = UIColor.lightGray
        
        
        FirebaseUserManager().currentUser { (user) in
            
            guard let user = user else {
                print("no user for you")
                return
            }
            
            self.userImageView.image = user.userImage
            let first = user.firstName!
            let last = user.lastName!
            self.userNameLabel.text = String(format: "\(first) \(last)")
            self.userEmailLabel.text = user.username
            self.userPhoneNumberLabel.text = user.phoneNumber
            self.roundAppropriateViews()

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func roundAppropriateViews() {
        self.userImageView.layer.borderWidth = 3.0
        self.userImageView.layer.borderColor = UIColor.white.cgColor
        self.userImageView.layer.cornerRadius = userImageView.frame.width/2
        userImageView.clipsToBounds = true
        
        self.userNameLabel.layer.cornerRadius = 3.0
        self.userEmailLabel.layer.cornerRadius = 3.0
        self.userPhoneNumberLabel.layer.cornerRadius = 3.0
    }

}
