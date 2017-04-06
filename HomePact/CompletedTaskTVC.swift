//
//  CompletedTaskTVC.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import SwipeCellKit

class CompletedTaskTVC: UITableViewController {
    
    let kCompletedTaskCellIdentifier = "completedTaskCell"
    var userManager:FirebaseUserManager!
    var groupManager:FirebaseGroupManager!
    var taskManager:FirebaseTaskManager!
    var completedTasks = [Task]()
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
                return
            }
            self.currentUser = user
            
            self.userManager.observeTaskIDs(for: user, in: .completed, with: { taskIDs, error  in
                
                if error != nil {
                    print("\(error)")
                }
                
                self.taskManager.observeTasks(with: taskIDs, with:{ observedTasks, error in
                    
                    if error != nil {
                        print("\(error)")
                    }
                    
                    if self.completedTasks.count == 0{
                        self.completedTasks = observedTasks
                        self.tableView.reloadData()
                    }else if self.completedTasks.count < observedTasks.count {
                        self.completedTasks = observedTasks
                        self.tableView.reloadData()
                    }else {
                        self.completedTasks = observedTasks
                    }

                
                })
                
            })
        }
        
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return completedTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: kCompletedTaskCellIdentifier, for: indexPath) as! CompletedTVCell
        cell.delegate = self
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.55)
        cell.configureWith(completedTasks[indexPath.row])
        
        return cell
    }

}

extension CompletedTaskTVC: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?{
        switch orientation {
        case .left:
                 return nil
        case .right:
            let deleteAction = SwipeAction(style: .destructive, title: "Delete", handler: { action, indexPath in
                
                let doomedTask = self.completedTasks[indexPath.row]
                self.completedTasks.remove(at: indexPath.row)
                
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
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
        case .right:
            options.transitionStyle = .border
            options.expansionStyle = SwipeExpansionStyle.destructive
        case .left:
            options.transitionStyle = .border
        }
        
        
        return options
        
    }

    
}
