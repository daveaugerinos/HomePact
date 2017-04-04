//
//  UpcomingTaskTVC.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import SwipeCellKit

class UpcomingTaskTVC: UITableViewController {

    let kUpcomingCellIdentifier = "upcomingTaskCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(52, 0, 0, 0)
        
        let fbUM = FirebaseUserManager()
        fbUM.currentUser({ user in
            guard let user = user else {
                print("booooooo")
                return
            }
            
            print("\(user.id)")
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kUpcomingCellIdentifier, for: indexPath) as! UpcomingTVCell
        cell.delegate = self

        // Configure the cell...
        

        return cell
    }
//
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//
//

}

extension UpcomingTaskTVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?{
        switch orientation {
        case .left:
            let editAction = SwipeAction(style: .default, title: "Edit", handler: { action, indexPath in
                ViewControllerRouter(self).showAddOrModify()
                print("yay edit")
            })
            editAction.image = #imageLiteral(resourceName: "Edit")
            return [editAction]
        case .right:
            let deleteAction = SwipeAction(style: .destructive, title: "Delete", handler: { action, indexPath in
                print("yay delete")
            })
            deleteAction.image = #imageLiteral(resourceName: "DeleteX")
            return [deleteAction]
        }
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions{
        var options = SwipeTableOptions()
        options.transitionStyle = .border
    
        return options
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
        
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
        
    }
 

    
}
