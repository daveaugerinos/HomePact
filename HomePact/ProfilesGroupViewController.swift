//
//  ProfilesGroupViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class ProfilesGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupView: RoundView!
    @IBOutlet fileprivate weak var groupNameLabel: UILabel!
    @IBOutlet fileprivate weak var groupUsersTableView: UITableView!
    @IBOutlet fileprivate weak var leaveButton: UIButton!
    var arrayOfUsers : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameLabel.layer.cornerRadius = 3.0
        groupNameLabel.text = ""
        leaveButton.layer.borderColor = UIColor.red.cgColor
        groupUsersTableView.backgroundColor = UIColor.clear
        groupUsersTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        FirebaseGroupManager().currentUserGroup { (group, error) -> (Void) in
            self.groupView.image = group?.groupImage
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
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! GroupTableViewCell
        let userToDisplay = arrayOfUsers[indexPath.row]
        cell.backgroundColor = UIColor.clear
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
