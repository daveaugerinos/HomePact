//
//  CompleteTaskViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class CompleteTaskViewController: UIViewController {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var addMediaImageView: UIImageView!
    @IBOutlet weak var extraDetailsTextField: UITextField!
    fileprivate var taskToComplete:Task!
    fileprivate var userManager: FirebaseUserManager!
    fileprivate var groupManager: FirebaseGroupManager!
    fileprivate var taskManager: FirebaseTaskManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userManager = FirebaseUserManager()
        groupManager = FirebaseGroupManager()
        taskManager = FirebaseTaskManager()
        
        if taskToComplete != nil  {
            taskNameLabel.text = taskToComplete.name

        }

        //enable interaction of addMediaImageView - ImagePickerController etc

    }
    
    func configure(with task:Task){
        
        taskToComplete = task
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        
        taskToComplete.isCompleted = true
        taskManager.update(taskToComplete)
        userManager.currentUser {  user in
            guard let user = user else {
                return
            }
            self.userManager.move(self.taskToComplete, for: user, from: .upcoming, to: .completed)
        }
        groupManager.currentUserGroup { group, error in
            
            guard let group = group else {
                return
            }
            self.groupManager.move(task: self.taskToComplete, in: group, from: .upcoming, to: .completed)
        }
        
        dismiss(animated: true, completion: nil)
    }

}


extension CompleteTaskViewController: UITextFieldDelegate {
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
  }







