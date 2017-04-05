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
        
        userManager.currentUser { user  in
            
            guard let user = user else {
                print("no user for you")
                return
            }
            self.currentUser = user
            let key1 = self.taskManager.tasksRef.childByAutoId().key
            let key2 = self.taskManager.tasksRef.childByAutoId().key
            
            var task1 = Task(id: key1, name: "wohooo", timestamp: Date())
            task1.taskDate = Date()
            task1.taskImage = #imageLiteral(resourceName: "default_person")
            task1.recurrenceTime = .none
            task1.notes = "you have a lot of work"
            task1.isCompleted = false
            
            var task2 = Task(id: key2, name: "yiiihaaa", timestamp: Date())
            task2.taskDate = Date()
            task2.taskImage = #imageLiteral(resourceName: "default_person")
            task2.recurrenceTime = .none
            task2.notes = "you have a lot of work"
            task2.isCompleted = false
            self.taskManager.update(task1)
            self.taskManager.update(task2)
            
            self.userManager.add(task1, to: self.currentUser, for: .upcoming)
            self.userManager.add(task2, to: self.currentUser, for: .upcoming)
            
            self.userManager.observeTaskIDs(for: user, in: .upcoming, with: { observedIDs, error  in
                
                if error != nil {
                    print("\(error)")
                }

                
                
                self.taskManager.observeTasks(with: observedIDs, with: { observedTasks, error  in
                    if error != nil {
                        print("\(error)")
                    }
                    if self.tasks.count == 0{
                        self.tasks = observedTasks
                        self.tableView.reloadData()
                    }else {
                        self.tasks = observedTasks
                    }
                    
                   
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
                
                self.userManager.remove(self.tasks[indexPath.row], from: self.currentUser, for: .upcoming)
                self.taskManager.delete(self.tasks[indexPath.row])
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
                
            })
            deleteAction.image = #imageLiteral(resourceName: "DeleteX")
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions{
        var options = SwipeTableOptions()
        options.transitionStyle = .border
        options.expansionStyle = SwipeExpansionStyle.destructive
        
        return options
        
    }
 
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
        
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
        
    }
 

    
}
