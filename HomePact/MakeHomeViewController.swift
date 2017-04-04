//
//  MakeHomeViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class MakeHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickYourHomeImageButton: PickImageButton!
    @IBOutlet weak var homeNameTextField: UITextField!
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet weak var sendInviteButton: UIButton!
    @IBOutlet weak var createHomeFeedbackView: RoundView!
    @IBOutlet weak var networkActivityView: UIView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var homeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = networkActivityView.center
        activityIndicator.frame = networkActivityView.bounds
        networkActivityView.addSubview(activityIndicator)
        createHomeFeedbackView.layer.isHidden = true
        makeButton.layer.borderColor = UIColor.white.cgColor
        sendInviteButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods -
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Use the orginal image in dictionary
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set button to display the selected image
        pickYourHomeImageButton.setImage(selectedImage, for: .normal)
        
        // Get home image for later upload
        homeImage = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Action Methods -

    @IBAction func joinButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showJoinHome()
    }
    
    @IBAction func pickHomeImageButtonTouched(_ sender: UIButton) {
        // Hide the keyboard
        homeNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = . photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func makeButtonTouched(_ sender: UIButton) {
        let currentImage = UIImage(named: "default_home.jpg")
        guard let homeName = homeNameTextField.text?.trimmingCharacters(in: .whitespaces).lowercased() else { return }
        
        // Check for home name
        if(homeName == "") {
            alert(title: "Home Name Required", message: "Please enter the name of your home.")
        }
        
        // Check for valid home name
        let regularExpression = "[a-zA-Z]{5,}"
        let nameValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let isValidName = nameValidation.evaluate(with: homeName)
        
        if(!isValidName) {
            alert(title: "Invalid Home Name", message: "Your home name must have minimum of 5 alphabet characters and no spaces.")
        }
        
        else {
            activityIndicator.startAnimating()
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            let groupRef = ref.child("groups")
            
            groupRef.queryOrdered(byChild:"name").queryEqual(toValue:homeName).observe(.value, with: { snapshot in
                
                if (snapshot.children.allObjects.count > 0) {
                    self.alert(title: "Invalid Home Name", message: "This name is already in use.  Please choose another one.")
                    self.activityIndicator.stopAnimating()
                    self.createHomeFeedbackView.layer.isHidden = true // REMOVE THIS AFTER TESTING
                }
                    
                else {
                    let key = FirebaseGroupManager().groupsRef.childByAutoId().key
                    var group = Group(id: key, name: homeName, timestamp: Date())
                    group.groupImage = currentImage
                    FirebaseGroupManager().update(group)
                    
                    if(FirebaseGroupManager().addCurrentUser(group: group)) {
                        self.activityIndicator.stopAnimating()
                        self.createHomeFeedbackView.layer.isHidden = false
                    }
                    
                    else {
                        self.alert(title: "Error", message: "Unable to add user to group.")
                        self.activityIndicator.stopAnimating()
                        self.createHomeFeedbackView.layer.isHidden = true // REMOVE THIS AFTER TESTING
                    }
                }
                
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    @IBAction func sendInviteButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showSendInvite()
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
