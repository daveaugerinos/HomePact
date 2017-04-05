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
    var userManager:FirebaseUserManager!
    var groupManager:FirebaseGroupManager!
    var taskManager:FirebaseTaskManager!
    var tasks = [Task]()
    var currentUser:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(52, 0, 0, 0)
        
        userManager = FirebaseUserManager()
        taskManager = FirebaseTaskManager()
        groupManager = FirebaseGroupManager()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        userManager.currentUser { user  in
            
            guard let user = user else {
                print("no user for you")
                return
            }
            self.currentUser = user
            self.userManager.observeTaskIDs(for: user, in: .upcoming, with: { observedIDs, error  in
                
                if error != nil {
                    print("\(error)")
                }
                
                self.taskManager.observeTasks(with: observedIDs, with: { observedTasks, error  in
                    if error != nil {
                        print("\(error)")
                    }
                    
                    self.tasks = observedTasks
                    self.tableView.reloadData()
                })
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kUpcomingCellIdentifier, for: indexPath) as! UpcomingTVCell
        cell.delegate = self
        
        cell.configureWith(tasks[indexPath.row])

        return cell
    }

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
                
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
                self.userManager.remove(self.tasks[indexPath.row], from: self.currentUser, for: .upcoming)
                self.tableView.endUpdates()
                
            })
            deleteAction.image = #imageLiteral(resourceName: "DeleteX")
            
            return [deleteAction]
        }
    }
 
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
        
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
        
    }
 

    
}
