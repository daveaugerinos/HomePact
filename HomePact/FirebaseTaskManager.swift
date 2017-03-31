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

   
    func observeTasks(with IDs:[String], with closure:@escaping (_ tasks:[Task],_ error:Error?)-> (Void) ){
        
        
        let query = tasksRef.queryOrderedByKey().queryStarting(atValue: IDs.first).queryEnding(atValue: IDs.last)
        query.observe(.value, with: {snapshot in
        
            let result = self.tasks(from: snapshot, with: IDs)
            closure(result.tasks, result.error)
        })
        
    
    

        
    }
    
    func tasks(from snapshot:FIRDataSnapshot, with IDs:[String]) ->(tasks:[Task], error:Error?){
        
        var tasks = [Task]()
        
        guard let value = snapshot.value as? NSDictionary else {
            let closureError = "Error accesing groups  IDs" as! Error
            return ([],closureError)
        }
        
        let filteredTasks = value.filter({ (key, value) in
            return IDs.contains(key as! String)
        })
        
        //filteredTasks to Task struct parsing
        

        
        return (tasks,nil)
    }

}


