//
//  JoinHomeViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class JoinHomeViewController: UIViewController {

    @IBOutlet weak var joinHomeTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var makeAHomeButton: UIButton!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var joinHomeFeedbackView: UIView!
    @IBOutlet weak var networkActivityView: UIView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = networkActivityView.center
        activityIndicator.frame = networkActivityView.bounds
        networkActivityView.addSubview(activityIndicator)
        joinHomeFeedbackView.layer.isHidden = true
        joinButton.layer.borderColor = UIColor.white.cgColor
        makeAHomeButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Action Methods -
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).popToRootVC()
    }
    
    @IBAction func joinButtonTouched(_ sender: UIButton) {
        guard let groupName = joinHomeTextField.text?.trimmingCharacters(in: .whitespaces).lowercased() else { return }
        
        // Check for home name
        if(groupName == "") {
            alert(title: "Home Name Required", message: "Please enter the name of the home you which to join.")
        }
        
        // Check for valid home name
        let regularExpression = "[a-zA-Z]{5,}"
        let nameValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let isValidName = nameValidation.evaluate(with: groupName)
        
        if(!isValidName) {
            alert(title: "Invalid Home Name", message: "A home name must have minimum of 5 alphabet characters and no spaces.")
        }
        
        else {
            activityIndicator.startAnimating()
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            let groupRef = ref.child("groups")
            
            groupRef.queryOrdered(byChild:"name").queryEqual(toValue:groupName).observe(.value, with: { snapshot in
            
                if (snapshot.children.allObjects.count == 0) {
                    self.alert(title: "Invalid Home Name", message: "Name not found.  Please choose another one.")
                    self.activityIndicator.stopAnimating()
                    self.joinHomeFeedbackView.layer.isHidden = true // REMOVE THIS AFTER TESTING
                }
                
                else {
                    for group in snapshot.children {
                        if let groupSnapshot = group as? FIRDataSnapshot {
                            let groupID = groupSnapshot.key
                            FirebaseGroupManager().group(groupID: groupID, with: { (group, error) in
                                if(error != nil) {
                                    print(error!)
                                }
                                else {
                                    if(FirebaseGroupManager().addCurrentUser(group: group!)) {
                                        self.activityIndicator.stopAnimating()
                                        self.joinHomeFeedbackView.layer.isHidden = false
                                        ViewControllerRouter(self).showRootTabBar()
                                    }
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func makeAHomeButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showMakeHome()
    }
    
    // MARK: - Alert -
    
    func alert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
    }
}
