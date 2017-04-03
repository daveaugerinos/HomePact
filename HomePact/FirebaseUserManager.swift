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
    case badAccess (String), parse(String)
}

class FirebaseUserManager:NSObject {
    
    //MARK: Root References
    var rootRef: FIRDatabaseReference
    var usersRef: FIRDatabaseReference
    var userTaskLogsRef: FIRDatabaseReference
    var userMessageLogsRef: FIRDatabaseReference
    var userGroupLogsRef: FIRDatabaseReference
    
    //MARK: INIT & DEINIT
     override init() {
        
        self.rootRef = FIRDatabase.database().reference()
        self.usersRef = rootRef.child("users")
        self.userTaskLogsRef = rootRef.child("userTaskLogs")
        self.userMessageLogsRef = rootRef.child("userMessageLogs")
        self.userGroupLogsRef = rootRef.child("userGroupLogs")
        super.init()
        
    }
    
    deinit{
        usersRef.removeAllObservers()
        userTaskLogsRef.removeAllObservers()
        userMessageLogsRef.removeAllObservers()
        userGroupLogsRef.removeAllObservers()
        
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
        guard let imageString = user.userImage?.base64Encode() else {
            return
        }
        
        
        let updates = [ "firstname" : firstname,
                        "lastname" : lastname,
                        "phonenumber" : phoneNumber,
                        "username" : user.username,
                        "uid": user.id,
                        "imageString": imageString]
        
        usersRef.updateChildValues(["/\(user.id)" : updates])
        
    }
    
     func currentUser(_ closure: @escaping (User?) ->(Void)){
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, FBUser) in
            
            
            guard let user = FBUser else {
                return
            }
            self.user(from: user.uid, with: { (user, closureError) in
                
                if let error = closureError {
                    print("\(error.localizedDescription)")
                    return
                }
                
                guard let appUser = user else {
                    return
                }
                closure(appUser)
                
            })
        })
        
    }
    
    func usersWith(userIDs:[String], closure:@escaping ([User]?, Error?) -> (Void)) {
        
      
        let query = usersRef.queryOrderedByKey().queryStarting(atValue: userIDs.first).queryEnding(atValue: userIDs.last)
        query.observe(.value, with: { snapshot in
            var users = [User]()
            var closureError: FBUMError?
            guard let usersDict = snapshot.value as? NSDictionary else {
                closureError = FBUMError.badAccess("Error accesing user IDs")
                return
            }
            
            let filteredUsers = usersDict.filter({ (key, _) in
                return userIDs.contains(key as! String)
            })
            
            for (_, value) in filteredUsers{
                
                
                guard let userInfo = value as? NSDictionary else {
                    closureError = FBUMError.parse("Error reading user info")
                    break
                }
                
                guard let user = self.parseUser(from: userInfo) else {
                    closureError = FBUMError.parse("Error parsing us info")
                    break
                }
                users.append(user)
            }
            
            closure(users, closureError)

        })
        
    }
    
    func user(from userID:String,with closure:@escaping (_ user:User?,_ error:Error?)-> (Void) ) {
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
        
        userTaskLogsRef.child(user.id).child(queryCondition).child(task.id).removeValue()

        
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
    
    //MARK: HELPER METHODS
    
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
            let closureError = FBUMError.badAccess("Error accesing user details")
            return (nil, closureError)
        }
       
        guard let user = parseUser(from: userInfo) else {
            let closureError = FBUMError.parse("Error parsing user")
            return(nil,closureError)
        }
        return (user,nil)
    }
    
    fileprivate func parseUser(from dictionary:NSDictionary) ->User? {
        
        let userName = dictionary.value(forKey: "username") as? String ?? ""
        let uid = dictionary.value(forKey: "uid") as? String ?? ""
        let firstName = dictionary.value(forKey: "firstname") as? String ?? ""
        let lastName = dictionary.value(forKey: "lastname") as? String ?? ""
        let phoneNumber = dictionary.value(forKey: "phonenumber") as? String ?? ""
        let imageString = dictionary.value(forKey: "imageString" ) as? String
        let userImage = imageString?.decodeBase64Image()
        
        var newUser = User(id: uid, username: userName, timestamp: Date())
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.phoneNumber = phoneNumber
        newUser.userImage = userImage
        return newUser
    }

    fileprivate func makeUserPaths(userID:String){
        
        usersRef.child(userID)
        userGroupLogsRef.child(userID)
        userTaskLogsRef.child(userID)
        userMessageLogsRef.child(userID)
        
    }
    
}
