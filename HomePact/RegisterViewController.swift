//
//  RegisterViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickYourImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - UITextFieldDelegate Methods -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods -
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Use the original image in dictionary
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image
        pickYourImageButton.setImage(selectedImage, for: .normal)
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action Methods -
    
    @IBAction func loginVCButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).popToRootVC()
    }

    @IBAction func pickYourImageButtonTouched(_ sender: UIButton) {
        // Hide the keyboard
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        reenterPasswordTextField.resignFirstResponder()

        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func clearTextPasswordButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func registerButtonTouched(_ sender: UIButton) {
        
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if((password?.characters.count)! < 5) {
            
            
            let alert = UIAlertController(title: "Invalid Password", message: "Password must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        }
        
        // *** ONLY TESTING CHANGE email! and password! ****
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                print("Error \(error)")
                return
            } else {
                print("Login successful")
                
                if let user = user {
                    let uid = user.uid  // Unique ID, which you can use to identify the user on the client side
                    let email = user.email
                    
                    // let photoURL = user.photoURL
                    
                    print("UID: \(uid)")
                    print("Email: \(email)")
                    
                    user.getTokenWithCompletion({ (token, error) in
                        let idToken = token  // ID token, which you can safely send to a backend
                        print("Token: \(idToken)")
                    })
                }
                return
            }
        })
        
        ViewControllerRouter(self).showJoinHome()
    }
}
