//
//  FirebaseUserManager.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-30.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase


enum FBUMError:Error {
    case badAccess (String)
}

class FirebaseUserManager:NSObject {
    
    //MARK: Root References
    var rootRef: FIRDatabaseReference
    var usersRef: FIRDatabaseReference
    var userTaskLogsRef: FIRDatabaseReference
    var userMessageLogsRef: FIRDatabaseReference
    var userGroupLogsRef: FIRDatabaseReference
    
    //MARK: INIT
     override init() {
        
        self.rootRef = FIRDatabase.database().reference()
        self.usersRef = rootRef.child("users")
        self.userTaskLogsRef = rootRef.child("userTaskLogs")
        self.userMessageLogsRef = rootRef.child("userMessageLogs")
        self.userGroupLogsRef = rootRef.child("userGroupLogs")
    
        
    }
    
    //MARK: USER METHODS
    
    func create(_ user: User){
        
        makeUserPaths(userID: user.id)
        updateDetails(user)
        
    }
    
    func updateDetails(_ user:User){
    
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
        
        usersRef.updateChildValues(["/\(user.id)" : updates])
        
    }
    
    
    func user(from  userID:String,with closure:@escaping (_ user:User?,_ error:Error?)-> (Void) ) {
        usersRef.child(userID).observeSingleEvent(of: .value, with:{ snapshot in
        
         let queryResult = self.user(from: snapshot)

         closure(queryResult.user, queryResult.error)
        })
        
    
    }
    
    
    //MARK: TASK METHODS

    func add(_ task:Task, to user:User, for condition:TaskCondition ) {
        
        var queryCondition: String
       
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue
        }
        
        userTaskLogsRef.child(user.id).child(queryCondition).child(task.id).setValue(true)
     
        
    }
    
    func remove(_ task:Task, from user:User, for condition: TaskCondition)  {
        var queryCondition: String
        
        switch condition {
        case .upcoming:
            queryCondition = condition.rawValue
        case .completed:
            queryCondition = condition.rawValue
        }
        
        userTaskLogsRef.child(user.id).child(queryCondition).child(task.id).setValue(nil)

        
    }
    
    func move(_ task:Task, for user: User, from condition: TaskCondition, to anotherCondition: TaskCondition) {
  
        remove( task, from: user, for: condition)
        add( task, to: user, for: anotherCondition)
    }
    
    
    
    
    
    //MARK: OBSERVER METHODS
    
    
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
    

    
    fileprivate func IDs(from snapshot:FIRDataSnapshot) ->(IDs:[String], error:Error?){
        
        var IDs = [String]()
        
        guard let value = snapshot.value as? NSDictionary else {
            let closureError = FBUMError.badAccess("Error accesing users  IDs") as Error
            return ([],closureError)
        }
        
        for (key,_) in value{
            
            guard let key = key as? String else {
                let closureError = FBUMError.badAccess("Error reading users IDs") as Error
                return([],closureError)

            }
            IDs.append(key)
        }
        
        return (IDs,nil)
        
    }
    
    fileprivate func user(from snapshot:FIRDataSnapshot) -> (user:User?, error:Error?){
        
        
        guard let userInfo = snapshot.value as? NSDictionary else {
            let closureError = "Error accesing user details" as! Error
            return (nil, closureError)
        }
        let userName = userInfo.value(forKeyPath: "username") as? String ?? ""
        let uid = userInfo.value(forKeyPath: "uid") as? String ?? ""
        let firstName = userInfo.value(forKeyPath: "firstname") as? String ?? ""
        let lastName = userInfo.value(forKeyPath: "lastname") as? String ?? ""
        let phoneNumber = userInfo.value(forKeyPath: "phonenumber") as? String ?? ""
            
        
        var newUser = User(id: uid, username: userName, timestamp: Date())
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.phoneNumber = phoneNumber
        
        return (newUser,nil)
    }
    
    fileprivate func makeUserPaths(userID:String){
        
        usersRef.child(userID)
        userGroupLogsRef.child(userID)
        userTaskLogsRef.child(userID)
        userMessageLogsRef.child(userID)
        
    }
    
}
