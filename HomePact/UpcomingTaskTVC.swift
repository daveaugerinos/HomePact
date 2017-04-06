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
    var upcomingTasks = [Task]()
    var currentUser:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(52, 0, 0, 0)
        tableView.backgroundView = UIImageView(image: UIImage(named: "LoginBackground"))
        tableView.backgroundView?.contentMode = .center
        tableView.backgroundView?.alpha = 0.75
        
        userManager = FirebaseUserManager()
        taskManager = FirebaseTaskManager()
        groupManager = FirebaseGroupManager()
        
        userManager.currentUser { user in
            
            guard let user = user else {
                print("no user for you")
                return
            }
            self.currentUser = user
            self.groupManager.currentUserGroup{group, error in
                
                guard let group = group else {
                    return
                }
                self.groupManager.observeTaskIDs(for: group, in: .upcoming, with:{ observedIDs, error in
                
                    self.taskManager.observeTasks(with: observedIDs, with: { observedTasks, error  in
                        
                        if error != nil {
                            print("\(error)")
                        }
                        self.upcomingTasks = observedTasks
                        self.tableView.reloadData()

                
                })
                
                })
            }
        }
    }
            
                
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return upcomingTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kUpcomingCellIdentifier, for: indexPath) as! UpcomingTVCell
        cell.delegate = self
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.55)
        cell.configureWith(upcomingTasks[indexPath.row])

        return cell
    }

}



extension UpcomingTaskTVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?{
        switch orientation {
        case .left:
            let editAction = SwipeAction(style: .default, title: "Edit", handler: { action, indexPath in
                ViewControllerRouter(self).presentAddTask()
                print("yay edit")
                action.fulfill(with: .reset)
            })
            let completeAction = SwipeAction(style: .default, title: "Complete", handler: { action, indexPath in
                action.fulfill(with: .reset)
                ViewControllerRouter(self).presentCompleteTask(with: self.upcomingTasks[indexPath.row])
                
                
            })
            editAction.image = #imageLiteral(resourceName: "Compose Icon")
            completeAction.image = #imageLiteral(resourceName: "Checkmark")
            return [editAction, completeAction]
        case .right:
            let deleteAction = SwipeAction(style: .destructive, title: "Delete", handler: { action, indexPath in
                
                let doomedTask = self.upcomingTasks[indexPath.row]
                self.upcomingTasks.remove(at: indexPath.row)
                
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
                
                self.groupManager.currentUserGroup({ group, error  in
                    self.groupManager.remove(task: doomedTask, from: group!, for: .upcoming)
               })
                self.userManager.remove(doomedTask, from: self.currentUser, for: .upcoming)
                self.taskManager.delete(doomedTask)
                self.tableView.endUpdates()
                
            })
            
            deleteAction.image = #imageLiteral(resourceName: "Trash")
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions{
        var options = SwipeTableOptions()

        switch orientation {
        case .left:
            options.transitionStyle = .border
            options.expansionStyle = SwipeExpansionStyle.fill
        case .right:
            options.expansionStyle = SwipeExpansionStyle.destructive
            options.transitionStyle = .border
        }
        
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.buttonPadding = 20
        
        return options
        
    }
    
}

extension UpcomingTaskTVC {
    

}
