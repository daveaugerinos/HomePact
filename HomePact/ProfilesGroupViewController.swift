//
//  ProfilesGroupViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class ProfilesGroupViewController: UIViewController {

    @IBOutlet fileprivate weak var groupImageView: UIImageView!
    @IBOutlet fileprivate weak var groupNameLabel: UILabel!
    @IBOutlet fileprivate weak var groupUsersTableView: UITableView!
    @IBOutlet fileprivate weak var leaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundAppropriateViews()
        self.view.backgroundColor = UIColor.lightGray
        
        let fbUM = FirebaseUserManager()
        let fbGM = FirebaseGroupManager()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leaveGroupButtonPressed(_ sender: UIButton) {
        //alert controller to ask for confirmation
    }

    func roundAppropriateViews() {
        self.groupImageView.layer.borderWidth = 3.0
        self.groupImageView.layer.borderColor = UIColor.white.cgColor
        self.groupImageView.layer.cornerRadius = groupImageView.frame.width/2
        
        self.groupNameLabel.layer.cornerRadius = 3.0
        self.leaveButton.layer.cornerRadius = 3.0
    }
    
    
    
}
