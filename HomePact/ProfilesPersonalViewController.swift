//
//  ProfilesPersonalViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfilesPersonalViewController: UIViewController {

    @IBOutlet weak var userView: RoundView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roundAppropriateViews()
        logoutButton.layer.borderColor = UIColor.red.cgColor
        
        FirebaseUserManager().currentUser { (user) in
            
            guard let user = user else { return }
            self.userView.image = user.userImage
            let first = user.firstName!
            let last = user.lastName!
            self.userNameLabel.text = String(format: "\(first) \(last)")
            self.userEmailLabel.text = user.username
            self.userPhoneNumberLabel.text = user.phoneNumber
            self.roundAppropriateViews()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func roundAppropriateViews() {
        self.userNameLabel.layer.cornerRadius = 3.0
        self.userEmailLabel.layer.cornerRadius = 3.0
        self.userPhoneNumberLabel.layer.cornerRadius = 3.0
    }

    @IBAction func logoutButtonTouched(_ sender: UIButton) {
    
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
            ViewControllerRouter(self).showLogin()
        } catch let error as NSError {
            if let errorCode = FIRAuthErrorCode(rawValue: (error._code)) {
                switch errorCode {
                case .errorCodeKeychainError:
                    self.alert(title: "Logout Error", message: "A error occurred when accessing the keychain.")
                default:
                    self.alert(title: "Logout Error", message: "An unusal error has occurred. Please contact support.")
                }
            }
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
