//
//  FirebaseGroupManager.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-30.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase


enum FBGMError:Error {
    case badAccess (String)
}
class FirebaseGroupManager: NSObject {

    //MARK: Root References
    var rootRef: FIRDatabaseReference
    var groupsRef: FIRDatabaseReference
    var groupTaskLogsRef: FIRDatabaseReference
    var groupUserLogsRef: FIRDatabaseReference
    var userGroupLogsRef: FIRDatabaseReference

    
    
    override init() {
        
        self.rootRef = FIRDatabase.database().reference()
        self.groupsRef = rootRef.child("groups")
        self.groupTaskLogsRef = rootRef.child("groupTaskLogs")
        self.groupUserLogsRef = rootRef.child("groupUserLogs")
        self.userGroupLogsRef = rootRef.child("userGroupLogs")
        
    }
    
    func update(_ group:Group){
        
        let updates = [ "name" : group.name,
                        "uid" : group.id ]
        
        
        groupsRef.updateChildValues(["/\(group.id)" : updates])
        
    }
    
    func add(user:User, to group:Group)   {
     groupUserLogsRef.child(group.id).child("members").child(user.id).setValue(true)
     userGroupLogsRef.child(user.id).child("memberOf").child(group.id).setValue(true)
    }
    
    func remove(user:User, from group:Group)  {
        groupUserLogsRef.child(group.id).child("members").child(user.id).removeValue()
    }
    
    func group(groupID:String,with closure:@escaping (_ group:Group?,_ error:Error?)-> (Void)) {
        
        groupsRef.child(groupID).observeSingleEvent(of: .value, with: {snapshot in
        
        let result = self.group(from: snapshot)
            
        closure(result.group, result.error)
        
        })
        
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
    
    
    fileprivate func IDs(from snapshot:FIRDataSnapshot) ->(IDs:[String], error:Error?){
        
        var IDs = [String]()
        
        guard let value = snapshot.value as? NSDictionary else {
            let closureError = FBGMError.badAccess("Error accesing groups IDs") as Error
            return ([],closureError)
        }
        
        for (key,_) in value{
            
            guard let key = key as? String else {
                let closureError = FBGMError.badAccess("Error reading groups IDs") as Error
                return([],closureError)
                
            }
            IDs.append(key)
        }
        
        return (IDs,nil)
        
    }
    
    fileprivate func group(from snapshot:FIRDataSnapshot) -> (group:Group?, error:Error?){
        
        
        guard let groupInfo = snapshot.value as? NSDictionary else {
            let closureError = FBGMError.badAccess("Error accesing group details") as Error
            return (nil, closureError)
        }
        let name = groupInfo.value(forKeyPath: "name") as? String ?? ""
        let uid = groupInfo.value(forKeyPath: "uid") as? String ?? ""
        
        let newGroup = Group(id: uid, name: name, timestamp: Date())
        return (newGroup,nil)
    }
    
}
