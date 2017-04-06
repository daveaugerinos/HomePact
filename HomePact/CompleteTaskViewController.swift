//
//  CompleteTaskViewController.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class CompleteTaskViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var extraDetailsTextField: UITextField!
    @IBOutlet weak var pickYourImageButton: PickImageButton!
    fileprivate var taskToComplete:Task!
    fileprivate var userManager: FirebaseUserManager!
    fileprivate var groupManager: FirebaseGroupManager!
    fileprivate var taskManager: FirebaseTaskManager!
    var completedTaskImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager = FirebaseUserManager()
        groupManager = FirebaseGroupManager()
        taskManager = FirebaseTaskManager()
        completedTaskImage = UIImage(named: "PhotoVideoGlyph")
        
        prepareViews()
    }
    
    func configure(with task:Task){
        taskToComplete = task
    }
    
    func prepareViews(){
        if taskToComplete != nil  {
            taskNameTextField.text = taskToComplete.name
        }
        
        taskNameTextField.underlined()
        extraDetailsTextField.underlined()
        
    }
    
    @IBAction func pickImageButtonPressed(_ sender: PickImageButton) {
        
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = . photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Use the orginal image in dictionary
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set button to display the selected image
        pickYourImageButton.setImage(selectedImage, for: .normal)
        
        // Get home image for later upload
        completedTaskImage = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        
        taskToComplete.isCompleted = true
        taskToComplete.taskImage = completedTaskImage
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









