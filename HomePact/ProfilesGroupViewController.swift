//
//  ProfilesGroupViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class ProfilesGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet fileprivate weak var groupImageView: UIImageView!
    @IBOutlet fileprivate weak var groupNameLabel: UILabel!
    @IBOutlet fileprivate weak var groupUsersTableView: UITableView!
    @IBOutlet fileprivate weak var leaveButton: UIButton!
    var arrayOfUsers : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundAppropriateViews()
        self.view.backgroundColor = UIColor.lightGray
        
        
        FirebaseGroupManager().currentUserGroup { (group, error) -> (Void) in
            self.groupImageView.image = group?.groupImage
            self.groupNameLabel.text = group?.name
            
            FirebaseGroupManager().observeUserIDs(for: group!) { (arrayOfIDs, error) -> (Void) in
                let arrayOfUserIDs = arrayOfIDs
                
                FirebaseUserManager().usersWith(userIDs: arrayOfUserIDs) { (returnedUsers, error) -> (Void) in
                    self.arrayOfUsers = returnedUsers!
                    self.groupUsersTableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leaveGroupButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Leave Group", message: "Are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "I'm sure", style: .default) { action in
            FirebaseUserManager().currentUser { (user) in
                FirebaseGroupManager().currentUserGroup { (group, error) -> (Void) in
                    FirebaseGroupManager().remove(user: user!, from: group!)
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true)
    }

    func roundAppropriateViews() {
        self.groupImageView.layer.borderWidth = 3.0
        self.groupImageView.layer.borderColor = UIColor.white.cgColor
        self.groupImageView.layer.cornerRadius = groupImageView.frame.width/2
        
        self.groupNameLabel.layer.cornerRadius = 3.0
    }
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! GroupTableViewCell
        let userToDisplay = arrayOfUsers[indexPath.row]
        cell.user = userToDisplay
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfUsers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
