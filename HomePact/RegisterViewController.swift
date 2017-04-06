//
//  RegisterViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickYourImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var createUserFeedbackView: RoundView!
    @IBOutlet weak var networkActivityView: UIView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = networkActivityView.center
        activityIndicator.frame = networkActivityView.bounds
        networkActivityView.addSubview(activityIndicator)
        createUserFeedbackView.layer.isHidden = true
        passwordTextField.isSecureTextEntry = true
        reenterPasswordTextField.isSecureTextEntry = true
        registerButton.layer.borderColor = UIColor.white.cgColor
        userImage = UIImage(named: "default_person.jpg")
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
        // Set button to display the selected image
        pickYourImageButton.setImage(selectedImage, for: .normal)
        
        // Get user image for later upload
        userImage = selectedImage
        
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

        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func showSecureTextPasswordButtonTouched(_ sender: UIButton) {
        let _ = passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        let _ = reenterPasswordTextField.isSecureTextEntry = !reenterPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func registerButtonTouched(_ sender: UIButton) {
        
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces).lowercased() else { return }
        guard let phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        let isValidEmail = regex?.firstMatch(in: email, options: [], range: NSMakeRange(0, (email.characters.count))) != nil
        
        let type: NSTextCheckingResult.CheckingType = .phoneNumber
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        
        let validPhoneNumber = detector.matches(in: phoneNumber, options: [], range: NSMakeRange(0, (phoneNumber.characters.count))).first?.phoneNumber
        
        // Minimum 8 characters, at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[~$@$#!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let isValid = passwordValidation.evaluate(with: password)
        
        // Check for first name
        if firstName.isEmpty {
            alert(title: "First Name Required", message: "Please enter your first name.")
        }
        
        // Check for last name
        else if lastName.isEmpty {
            alert(title: "Last Name Required", message: "Please enter your last name.")
        }
        
        // Check for valid email
        else if email.isEmpty {
            alert(title: "Valid Email Required", message: "Please enter your email address.")
        }

        else if !isValidEmail {
            alert(title: "Invalid Email Address", message: "Please enter a valid email address.")
        }
        
        // Check for valid phone number
        else if phoneNumber.isEmpty {
            alert(title: "Phone Number Required", message: "Please enter your phone number.")
        }
 
        else if validPhoneNumber == nil {
            alert(title: "Valid Phone Number Required", message: "Please enter a valid phone number (e.g. 5552228888.")
        }

        // Check for matching passwords
        else if(passwordTextField.text != reenterPasswordTextField.text) {
            alert(title: "Passwords Do Not Match", message: "Please ensure your password matches.")
        }
        
        else if !isValid  {
            alert(title: "Invalid Password", message: "Your password must have a minimum of 8 characters, at least 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character.")
        }
        
        else {
            // Provide feedback while making network call
            activityIndicator.startAnimating()
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                    self.activityIndicator.stopAnimating()
                    if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                        switch errorCode {
                        case .errorCodeNetworkError:
                            self.alert(title: "Sign Up Error", message: "A network error occurred.")
                        case .errorCodeOperationNotAllowed:
                            self.alert(title: "Sign Up Error", message: "Username and password account not currently enabled.")
                        case .errorCodeInvalidEmail:
                            self.alert(title: "Sign Up Error", message: "The email address improperly formed.")
                        case .errorCodeEmailAlreadyInUse:
                            self.alert(title: "Sign Up Error", message: "The email used to attempt sign up already exists.")
                        case .errorCodeWeakPassword:
                            self.alert(title: "Sign Up Error", message: "You have enter a password that is considered too weak.")
                        default:
                            self.alert(title: "Sign Up Error", message: "An unusal error has occurred. Please contact support.")
                        }
                    }
                }
                
                else {
                    guard let user = user else { return }
                    
                    // Upload user info
                    var currentUser = User(id: user.uid, username: email, timestamp: Date())
                    
                    currentUser.firstName = firstName
                    currentUser.lastName = lastName
                    currentUser.phoneNumber = phoneNumber
                    currentUser.userImage = self.userImage
                    
                    FirebaseUserManager().create(currentUser)
                    
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                        self.createUserFeedbackView.layer.isHidden = false
                        ViewControllerRouter(self).showJoinHome()
                    })
                }
            })
            return
        }
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
