//
//  FirebaseUserManager.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-30.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase


class FirebaseUserManager:NSObject {
    
    //MARK: Root References
    var rootRef: FIRDatabaseReference
    var usersRef: FIRDatabaseReference
    var userTaskLogsRef: FIRDatabaseReference
    var userMessageLogsRef: FIRDatabaseReference
    var userGroupLogsRef: FIRDatabaseReference
    
    
     override init() {
        
        self.rootRef = FIRDatabase.database().reference()
        self.usersRef = rootRef.child("users")
        self.userTaskLogsRef = rootRef.child("userTaskLogs")
        self.userMessageLogsRef = rootRef.child("userMessageLogs")
        self.userGroupLogsRef = rootRef.child("userGroupLogs")
    
        
    }
    
    func update(_ user:User){
    
        guard let firstname = user.firstName else{
            return
        }
        
        guard let lastname = user.lastName else {
            return
        }
        guard let phoneNumber = user.phoneNumber else {
            return
        }
        let updates = [ "firstname" : firstname,
                        "lastname" : lastname,
                        "phonenumber" : phoneNumber,
                        "username" : user.username,
                        "uid": user.id]
        
        usersRef.updateChildValues(["\(user.id)" : updates])
        
    }
    
    func add(task:Task, to user:User, for condition:TaskCondition ) {
        
        var queryCondition: String
       
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue
        }
        
        userTaskLogsRef.child(user.id).child(queryCondition).child(task.id).setValue(true)
     
        
    }
    
    func remove(task:Task, from user:User, for condition: TaskCondition)  {
        var queryCondition: String
        
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue
        }
        
        userTaskLogsRef.child(user.id).child(queryCondition).child(task.id).setValue(nil)

        
    }
    
    func move(task:Task, from user: User, from condition: TaskCondition, to anotherCondition: TaskCondition) {
  
        remove(task: task, from: user, for: condition)
        add(task: task, to: user, for: anotherCondition)
    }
    
    
    
    func observeGroupIDs(for user:User, with closure:@escaping (_ groupIDs:[String],_ error:Error?)-> (Void) ) {
        let query = userGroupLogsRef.child(user.id).child("memberOf").queryOrderedByKey()
       
        query.observeSingleEvent(of: .value, with: { snapshot in
           
            let queryResults = self.IDs(from: snapshot)
            
            closure(queryResults.IDs, queryResults.error)
            
        })
        
    }
    
    func observeMessageIDs(for user:User, with closure:@escaping (_ groupIDs:[String],_ error:Error?)-> (Void) ) {
        let query = userMessageLogsRef.child(user.id).queryOrderedByKey()
        
        query.observe( .value, with: { snapshot in
            
            let queryResults = self.IDs(from: snapshot)
            
            closure(queryResults.IDs, queryResults.error)
            
        })
        
    }
    
    func observeTaskIDs(for user:User, in condition:TaskCondition, with closure:@escaping (_ taskIDs:[String],_ error:Error?)-> (Void) ) {
        
        var queryCondition:String
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue

        }
        
        let query = userTaskLogsRef.child(user.id).child(queryCondition).queryOrderedByKey()
        query.observe( .value, with: { snapshot in
            
            let queryResults = self.IDs(from: snapshot)
            
            closure(queryResults.IDs, queryResults.error)
            
        })
        
    }
    

    
    func IDs(from snapshot:FIRDataSnapshot) ->(IDs:[String], error:Error?){
        
        var IDs = [String]()
        
        guard let value = snapshot.value as? NSDictionary else {
            let closureError = "Error accesing users  IDs" as! Error
            return ([],closureError)
        }
        
        for (key,_) in value{
            
            guard let key = key as? String else {
                let closureError = "Error reading users IDs" as! Error
                return([],closureError)

            }
            IDs.append(key)
        }
        
        return (IDs,nil)
        
    }
}
