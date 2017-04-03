//
//  JoinHomeViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

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
        guard let homeName = joinHomeTextField.text?.trimmingCharacters(in: .whitespaces).lowercased() else { return }
        
        // Check for home name
        if(homeName == "") {
            alert(title: "Home Name Required", message: "Please enter the name of the home you which to join.")
        }
        
        // Check for valid home name
        let regularExpression = "[a-zA-Z]{5,}"
        let nameValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let isValidName = nameValidation.evaluate(with: homeName)
        
        if(!isValidName) {
            alert(title: "Invalid Home Name", message: "A home name must have minimum of 5 alphabet characters and no spaces.")
        }
        
        // check to see if home exists
        
        // if home exists check if user has invite
        
        // if user has invite, add user to home
        
        // TESTING!!!! Call create database home method
        activityIndicator.startAnimating()
        activityIndicator.stopAnimating()
        joinHomeFeedbackView.layer.isHidden = false
        // **** homeImageView.image = image
        print("Join Home Name: \(homeName)")
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
