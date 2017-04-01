//
//  FirebaseTaskManager.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-30.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase


enum TaskCondition:String {
    case upcoming = "upcoming", completed = "completed"
}

enum FBTMError:Error {
    case badAccess (String)
}

class FirebaseTaskManager: NSObject {

    //MARK: Root References
    var rootRef: FIRDatabaseReference
    var tasksRef: FIRDatabaseReference
    var taskLogsRef: FIRDatabaseReference
    
    
    
    override init() {
        
        self.rootRef = FIRDatabase.database().reference()
        self.tasksRef = rootRef.child("tasks")
        self.taskLogsRef = rootRef.child("taskLogs")
        
    }

    func update(_ task:Task){

        guard let taskDate = task.taskDate?.timeIntervalSince1970 else {
            return
        }
        guard let notes = task.notes else {
            return
        }
        let updates = ["uid" : task.id,
                       "name" : task.name,
                       "taskDate" : taskDate,
                       "recurenceTime" : task.recurrenceTime.rawValue,
                       "notes" : notes,
                       "timestamp" : task.timestamp.timeIntervalSince1970,
                       "isCompleted" : task.isCompleted] as [String : Any]
        
        tasksRef.updateChildValues(["/\(task.id)" : updates])
    }
    
     
    
    func observeTasks(with IDs:[String], with closure:@escaping (_ tasks:[Task],_ error:Error?)-> (Void) ){
        
        
        let query = tasksRef.queryOrderedByKey().queryStarting(atValue: IDs.first).queryEnding(atValue: IDs.last)
        query.observe(.value, with: {snapshot in
        
            let result = self.tasks(from: snapshot, with: IDs)
            closure(result.tasks, result.error)
        })
        
    }
    
   fileprivate func tasks(from snapshot:FIRDataSnapshot, with IDs:[String]) ->(tasks:[Task], error:Error?){
        
        var tasks = [Task]()
        var closureError: FBTMError
        guard let tasksDict = snapshot.value as? NSDictionary else {
            closureError = FBTMError.badAccess("Error accesing groups IDs")
            return ([],closureError)
        }
        
        let filteredTasks = tasksDict.filter({ (key, _) in
            return IDs.contains(key as! String)
        })
    
    for (_, value) in filteredTasks{
        
            
            guard let taskInfo = value as? NSDictionary else {
                closureError = FBTMError.badAccess("Error reading task info")
                break
            }
            
            guard let taskID = taskInfo.value(forKey:"uid") as? String else {
                break
            }
            guard let taskName = taskInfo.value(forKey: "name") as? String else {
                break
            }
            guard let taskDate = taskInfo.value(forKey: "taskDate") as? TimeInterval else {
                break
            }
            guard let recurrenceTime = Task.RecurrenceTime(rawValue:(taskInfo.value(forKey: "recurrenceTime")as! String)) else {
                break
            }
            guard let notes = taskInfo.value(forKey: "notes") as? String else {
                break
            }
            guard let timestamp = taskInfo.value(forKey: "timestamp") as? TimeInterval else {
                break
            }
            guard let isCompleted = taskInfo.value(forKey: "isCompleted") as? Bool else {
                break
            }

            var task = Task(id: taskID, name: taskName, timestamp: Date(timeIntervalSince1970: timestamp))
            task.taskDate = Date(timeIntervalSince1970:taskDate)
            task.recurrenceTime = recurrenceTime
            task.notes = notes
            task.isCompleted = isCompleted
        
            tasks.append(task)
        }
        print("\(tasks)")
        //filteredTasks to Task struct parsing
        

        
        return (tasks,nil)
    }


}


