//
//  SendInviteViewController.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-04-03.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class SendInviteViewController: UIViewController, FIRInviteDelegate {

    @IBOutlet weak var sendInviteTextField: UITextField!
    @IBOutlet weak var sendInviteFeedbackView: RoundView!
    @IBOutlet weak var networkActivityView: UIView!
    @IBOutlet weak var sendInviteButton: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = networkActivityView.center
        activityIndicator.frame = networkActivityView.bounds
        networkActivityView.addSubview(activityIndicator)
        sendInviteFeedbackView.layer.isHidden = true
        sendInviteButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func makeButtonTouched(_ sender: UIButton) {
        ViewControllerRouter(self).showMakeHome()
    }
    
    @IBAction func sendInviteButtonTouched(_ sender: UIButton) {
        guard let email = sendInviteTextField.text?.trimmingCharacters(in: .whitespaces).lowercased() else { return }
        
        // Check for email
        if email.isEmpty {
            alert(title: "Email Required", message: "Please enter the email address to send the invite.")
        }
        
        else {
            // Provide feedback while making network call
            activityIndicator.startAnimating()
            
            // Send invite
            if let invite = FIRInvites.inviteDialog() {
                invite.setInviteDelegate(self)
                invite.setMessage("Sign Up for HomePact Today!")
                invite.setTitle("HomePact App Invite")
                invite.setDeepLink("app_url")
                invite.setDescription("Home is where the heart is.")
                invite.setCallToActionText("Install!")
                invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
                invite.open()
            }
            
            activityIndicator.stopAnimating()
            sendInviteFeedbackView.layer.isHidden = false
        }
    }
    
    func inviteFinished(withInvitations invitationIds: [Any], error: Error?) {
        if let error = error {
            print("Failed: " + error.localizedDescription)
        } else {
            print("Invitations sent")
        }
    }
    
    @IBAction func googleButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func facebookButtonTouched(_ sender: UIButton) {
    }

    
    @IBAction func twitterButtonTouched(_ sender: UIButton) {
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
