//
//  AddOrModifyVC.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import Firebase

class AddOrModifyVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak fileprivate var taskNameTextField: UITextField!
    @IBOutlet weak fileprivate var dateTextField: UITextField!
    @IBOutlet weak fileprivate var recurrenceTextField: UITextField!
    @IBOutlet weak fileprivate var groupMembersCollectionView: UICollectionView!
    @IBOutlet weak var pickYourImageButton: PickImageButton!
    @IBOutlet weak fileprivate var repeatDetailsView: UIView!
    @IBOutlet weak fileprivate var repeatSlider: UISlider!
    @IBOutlet weak fileprivate var repeatNumberOfTimesLabel: UILabel!
    @IBOutlet weak fileprivate var addMediaImageView: UIImageView!
    var taskImage: UIImage?
    var taskDate = Date()
    let arrayOfRecurrences = ["Once-off", "Weekly", "Fortnightly", "Monthly", "Quarterly", "Yearly"]
    var arrayOfUsers: [User] = []
    let recurrencePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupMembersCollectionView.allowsMultipleSelection = true
        prepareViews()
        configureCollectionDataSource()
        
        taskImage = UIImage(named: "PhotoVideoGlyph")

    }
    
    func prepareViews() {
        repeatDetailsView.alpha = 0
        repeatDetailsView.isUserInteractionEnabled = false
        repeatNumberOfTimesLabel.text = ""
        let array = [taskNameTextField, dateTextField, recurrenceTextField]
        for i in array {
            i!.underlined()
        }
        
        recurrenceTextField.text = arrayOfRecurrences[0]
        recurrencePickerView.delegate = self
        recurrencePickerView.dataSource = self
        recurrenceTextField.inputView = recurrencePickerView
        
        //make Done button
        let doneButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        doneButton.backgroundColor = UIColor.white
        doneButton.addTarget(self, action: #selector(doneButtonPressed(_ :)), for: UIControlEvents.touchUpInside)
        
        //get current date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        dateTextField.text = formatter.string(from: date)
        
        //make date picker with current date and Done button
        let datepickerView = UIDatePicker()
        datepickerView.timeZone = NSTimeZone.local
        datepickerView.minuteInterval = 5
        datepickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datepickerView
        dateTextField.inputAccessoryView = doneButton
        
        recurrenceTextField.inputAccessoryView = doneButton
        
    }
    
    //MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        
        guard let taskName = taskNameTextField.text else { return }
        
        if ((self.groupMembersCollectionView.indexPathsForSelectedItems) == nil) {
            alert(title: "Group Members Required", message: "Please select one or more people to do your task.")
        }
        
        // Check for home name
        if(taskName == "") {
            alert(title: "Task Name Required", message: "Please enter the name of your new task.")
        }
            
        else {
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            _ = ref.child("tasks")
            
            DispatchQueue.main.async(execute: {
                let key = FirebaseTaskManager().tasksRef.childByAutoId().key
                var newTask = Task(id: key, name: taskName, timestamp: Date())
                
                newTask.taskDate = self.taskDate
                
                //encode recurrence to enum
                switch (self.recurrenceTextField.text!) {
                case "Once-off":
                    newTask.recurrenceTime = .none
                case "Weekly":
                    newTask.recurrenceTime = .week
                case "Fortnightly":
                    newTask.recurrenceTime = .fortnight
                case "Monthly":
                    newTask.recurrenceTime = .month
                case "Quarterly":
                    newTask.recurrenceTime = .quarter
                case "Yearly":
                    newTask.recurrenceTime = .year
                default:
                    print("yay enum worked")
                }
                
                newTask.notes = "You have a lot of work to do!"
                newTask.taskImage = self.taskImage
                newTask.isCompleted = false
                
                print("TASK: \(newTask)")
                
                FirebaseTaskManager().update(newTask)
                
                //gets current user group
                FirebaseGroupManager().currentUserGroup { (group, error) -> (Void) in
                    //adds task to group
                    FirebaseGroupManager().add(task: newTask, to: group!, for: .upcoming)
                    
                }
                
                //gets current user
                FirebaseUserManager().currentUser({ (user) -> (Void) in
                    FirebaseUserManager().add(newTask, to: user!, for: .upcoming)
                })
                
                let selectedIndexPaths = self.groupMembersCollectionView.indexPathsForSelectedItems
                
                var selectedUsers : [User] = []
                for ip in selectedIndexPaths! {
                    let user = self.arrayOfUsers[ip.row]
                    selectedUsers.append(user)
                }
                
                for eachUser in selectedUsers {
                    FirebaseUserManager().add(newTask, to: eachUser, for: .upcoming)
                }
                
                ViewControllerRouter(self).showRootTabBar()
            })
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        repeatNumberOfTimesLabel.text = String(format: "\(Int(sender.value)) times")
    }
    
    //MARK: Show Pickers
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        dateTextField.text = selectedDate
        taskDate = sender.date
    }
    
    func doneButtonPressed(_ sender:UIButton)
    {
        recurrenceTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    @IBAction func pickImageButtonPressed(_ sender: PickImageButton) {
        recurrenceTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
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
        taskImage = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIPickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfRecurrences[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recurrenceTextField.text = arrayOfRecurrences[row]
        if row >= 1 {
            repeatDetailsView.alpha = 1.0
            repeatDetailsView.isUserInteractionEnabled = true
        } else {
            repeatDetailsView.alpha = 0.0
            repeatDetailsView.isUserInteractionEnabled = false
        }
    }
    
    //MARK: UIPickerView DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfRecurrences.count
    }
    
    //MARK: Collection View Methods
    
    func configureCollectionDataSource() {
        
        FirebaseGroupManager().currentUserGroup { (group, error) -> (Void) in
            FirebaseGroupManager().observeUserIDs(for: group!) { (arrayOfIDs, error) -> (Void) in
                let arrayOfUserIDs = arrayOfIDs
                
                FirebaseUserManager().usersWith(userIDs: arrayOfUserIDs) { (returnedUsers, error) -> (Void) in
                    self.arrayOfUsers = returnedUsers!
                    self.groupMembersCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! AddOrModifyCVCell
        let userForCell = arrayOfUsers[indexPath.item]
        cell.user = userForCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
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
