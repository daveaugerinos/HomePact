//
//  CompleteTaskViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class CompleteTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var addMediaImageView: UIImageView!
    @IBOutlet weak var extraDetailsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enable interaction of addMediaImageView - ImagePickerController etc

    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        //save new completed task
        //ViewControllerRouter(self).showCompleted()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
}
