//
//  FirebaseGroupManager.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-30.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class FirebaseGroupManager: NSObject {

    //MARK: Root References
    var rootRef: FIRDatabaseReference
    var groupsRef: FIRDatabaseReference
    var groupTaskLogsRef: FIRDatabaseReference
    var groupUserLogsRef: FIRDatabaseReference
    
    
    override init() {
        
        self.rootRef = FIRDatabase.database().reference()
        self.groupsRef = rootRef.child("groups")
        self.groupTaskLogsRef = rootRef.child("groupTaskLogs")
        self.groupUserLogsRef = rootRef.child("groupUserLogs")
        
        
    }
    
    func update(_ group:Group){
        
    }
    
    func add(task:Task, to group:Group, for condition:TaskCondition ) {
        
        var queryCondition: String
        
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue
        }
        
        groupTaskLogsRef.child(group.id).child(queryCondition).child(task.id).setValue(true)
        
        
    }
    
    func remove(task:Task, from group:Group, for condition: TaskCondition)  {
        var queryCondition: String
        
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue
        }
        
        groupTaskLogsRef.child(group.id).child(queryCondition).child(task.id).setValue(nil)
        
        
    }
    
    func move(task:Task, from group: Group, from condition: TaskCondition, to anotherCondition: TaskCondition) {
        
        remove(task: task, from: group, for: condition)
        add(task: task, to: group, for: anotherCondition)
    }
    
    
    
    func observeUserIDs(for group:Group, with closure:@escaping (_ userIDs:[String],_ error:Error?)-> (Void) ) {
        let query = groupUserLogsRef.child(group.id).child("members").queryOrderedByKey()
        
        query.observe( .value, with: { snapshot in
            
            let queryResults = self.IDs(from: snapshot)
            
            closure(queryResults.IDs, queryResults.error)
            
        })
        
    }

    func getTaskIDs(for group:Group, in condition:TaskCondition, with closure:@escaping (_ taskIDs:[String],_ error:Error?)-> (Void) ) {
        
        var queryCondition:String
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue
            
        }
        
        let query = groupTaskLogsRef.child(group.id).child(queryCondition).queryOrderedByKey()
        query.observe( .value, with: { snapshot in
            
            let queryResults = self.IDs(from: snapshot)
            
            closure(queryResults.IDs, queryResults.error)
            
        })
        
    }
    
    
    func IDs(from snapshot:FIRDataSnapshot) ->(IDs:[String], error:Error?){
        
        var IDs = [String]()
        
        guard let value = snapshot.value as? NSDictionary else {
            let closureError = "Error accesing groups  IDs" as! Error
            return ([],closureError)
        }
        
        for (key,_) in value{
            
            guard let key = key as? String else {
                let closureError = "Error reading groups IDs" as! Error
                return([],closureError)
                
            }
            IDs.append(key)
        }
        
        return (IDs,nil)
        
    }
    
}
