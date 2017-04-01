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
                       "reccurenceTime" : task.recurrenceTime.rawValue,
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
        
        guard let value = snapshot.value as? NSDictionary else {
            let closureError = FBTMError.badAccess("Error accesing groups  IDs") as Error
            return ([],closureError)
        }
        
        let filteredTasks = value.filter({ (key, value) in
            return IDs.contains(key as! String)
        })
        
        print("\(filteredTasks)")
        //filteredTasks to Task struct parsing
        

        
        return (tasks,nil)
    }


}


