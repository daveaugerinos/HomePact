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
        let homeName = joinHomeTextField.text?.trimmingCharacters(in: .whitespaces).lowercased()
        
        // Check for home name
        if(homeName == "" || homeName == nil) {
            let alert = UIAlertController(title: "Home Name Required", message: "Please enter the name of the home you which to join.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        
        // Check for valid home name
        let regularExpression = "[a-zA-Z]{5,}"
        let nameValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let isValidName = nameValidation.evaluate(with: homeName)
        
        if(!isValidName) {
            let alert = UIAlertController(title: "Invalid Home Name", message: "A home name must have minimum of 5 alphabet characters and no spaces.", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        
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
}
