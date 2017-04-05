//
//  FirebaseTestViewController.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-31.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class FirebaseTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firebaseUM = FirebaseUserManager()
        let firebaseGM = FirebaseGroupManager()
        let firebaseTM = FirebaseTaskManager()
        
        FIRAuth.auth()?.createUser(withEmail: "ipf@example.com", password: "password", completion: { (user, error) in
            guard let user = user else {
                print("error making user")
                return
            }
            
            var firebender  = User(id: user.uid, username: user.email!, timestamp: Date())
            firebender.firstName = "Reginal"
            firebender.lastName = "Jackson"
            firebender.phoneNumber = "7778889999"
            firebaseUM.create(firebender)
            
            
            firebaseUM.getUser(from: user.uid, with: { (fireBender, error) -> (Void) in
                
                
                
                let key = firebaseGM.groupsRef.childByAutoId().key
                let group = Group(id: key, name: "Sunshite", timestamp: Date())
                firebaseGM.update(group)
                firebaseGM.add(user: fireBender!, to: group)
                firebaseUM.observeGroupIDs(for: fireBender!, with: { (IDs, error) -> (Void) in
                    
                    if IDs.contains(group.id){
                        print("yay")
                    }
                  
                    firebaseGM.group(groupID: group.id, with: { (yay, error) -> (Void) in
                        
                        
                        print("\(String(describing: yay)), \(String(describing: error))")
                    })
                    
                })
            })
            
            
        })
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
