//
//  FirebaseTaskManager.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-30.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase


public enum TaskCondition:String {
    case upcoming = "upcoming", completed = "completed"
}

public enum FBTMError:Error {
    case badAccess (String), parse(String)
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
    
    deinit {
        tasksRef.removeAllObservers()
        taskLogsRef.removeAllObservers()
    }

    func update(_ task:Task){

        guard let taskDate = task.taskDate?.timeIntervalSince1970 else {
            return
        }
        guard let notes = task.notes else {
            return
        }
        guard let imageString = task.taskImage?.base64Encode() else {
            return
        }
        guard let assignedTo = task.assignedTo?.base64Encode() else {
            return
        }
        guard let nextAssigned = task.nextAssigned?.base64Encode() else {
            return
        }
        let updates = ["uid" : task.id,
                       "name" : task.name,
                       "taskDate" : taskDate,
                       "recurrenceTime" : task.recurrenceTime.rawValue,
                       "notes" : notes,
                       "timestamp" : task.timestamp.timeIntervalSince1970,
                       "isCompleted" : task.isCompleted,
                       "imageString" : imageString,
                       "assignedToUserImage" : assignedTo,
                       "nextAssignedUserImage" : nextAssigned] as NSDictionary
        tasksRef.updateChildValues(["\(task.id)" : updates])
    }
    
    
    func delete(_ task:Task){
        tasksRef.child(task.id).removeValue()
    }
    
     
    
    func observeTasks(with IDs:[String], with closure:@escaping (_ tasks:[Task],_ error:Error?)-> (Void) ){
    
        tasksRef.observe(.value, with: {snapshot in
        
            let result = self.tasks(from: snapshot, with: IDs)
            closure(result.tasks, result.error)
        })
        
    }
    
    fileprivate func tasks(from snapshot:FIRDataSnapshot, with IDs:[String]) ->(tasks:[Task], error:Error?){
        
        var tasks = [Task]()
        var closureError: FBTMError?
        guard let tasksDict = snapshot.value as? NSDictionary else {
            closureError = FBTMError.badAccess("Error accesing groups IDs")
            return ([],closureError)
        }
     
        
        for (key, value) in tasksDict {
            guard let key = key as? String else {
                break
            }
            if IDs.contains(key){
                guard let taskInfo = value as? NSDictionary else {
                    closureError = FBTMError.parse("Error reading task info")
                    break
                }
                guard let task = parseToTask(dictionary: taskInfo) else {
                    closureError = FBTMError.parse("Error parsing task info")
                    break
                }
                tasks.append(task)
            }
        }
        print("\(tasks)")
        //filteredTasks to Task struct parsing
        
        
        if closureError != nil{
            return (tasks,closureError)
        }
        return (tasks,nil)
        
    }
    
    
    fileprivate func parseToTask(dictionary:NSDictionary) -> Task? {
       
        guard let taskID = dictionary.value(forKey:"uid") as? String else {
            return nil
        }
        guard let taskName = dictionary.value(forKey: "name") as? String else {
            return nil
        }
        guard let taskDate = dictionary.value(forKey: "taskDate") as? TimeInterval else {
            return nil
        }
        guard let recurrenceTime = Task.RecurrenceTime(rawValue:(dictionary.value(forKey: "recurrenceTime")as! String)) else {
            return nil
        }
        guard let notes = dictionary.value(forKey: "notes") as? String else {
            return nil
        }
        guard let timestamp = dictionary.value(forKey: "timestamp") as? TimeInterval else {
            return nil
        }
        guard let isCompleted = dictionary.value(forKey: "isCompleted") as? Bool else {
            return nil
        }
        guard let imageString = dictionary.value(forKey: "imageString") as? String else {
            return nil
        }
        guard let assignedToImageString = dictionary.value(forKey: "assignedToUserImage") as? String else {
            return nil
        }
        guard let nextAssignedImageString = dictionary.value(forKey: "nextAssignedUserImage") as? String else {
            return nil
        }
        
        let image = imageString.decodeBase64Image()
        let assignedTo = assignedToImageString.decodeBase64Image()
        let nextAssigned = nextAssignedImageString.decodeBase64Image()
        
        var task = Task(id: taskID, name: taskName, timestamp: Date(timeIntervalSince1970: timestamp))
        
        task.taskDate = Date(timeIntervalSince1970:taskDate)
        task.recurrenceTime = recurrenceTime
        task.notes = notes
        task.isCompleted = isCompleted
        task.taskImage = image
        task.assignedTo = assignedTo
        task.nextAssigned = nextAssigned
        
        return task
    }


}


