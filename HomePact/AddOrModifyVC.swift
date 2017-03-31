//
//  AddOrModifyVC.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class AddOrModifyVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak fileprivate var taskNameTextField: UITextField!
    @IBOutlet weak fileprivate var dateTextField: UITextField!
    @IBOutlet weak fileprivate var recurrenceTextField: UITextField!
    
    @IBOutlet weak fileprivate var groupMembersCollectionView: UICollectionView!
    
    @IBOutlet weak fileprivate var repeatDetailsView: UIView!
    @IBOutlet weak fileprivate var repeatSlider: UISlider!
    @IBOutlet weak fileprivate var repeatNumberOfTimesLabel: UILabel!
    
    @IBOutlet weak fileprivate var addMediaImageView: UIImageView!
    
    let arrayOfRecurrences = ["Once-off", "Weekly", "Fortnightly", "Monthly", "Quarterly", "Yearly"]
    var arrayOfUsers: [User] = []
    let recurrencePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViews()
        configureCollectionDataSource()
    }
    
    func prepareViews() {
        addMediaImageView.isUserInteractionEnabled = true
        addMediaImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addMediaImageViewTapped(_:))))
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
        
        let doneButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        doneButton.backgroundColor = UIColor.white
        doneButton.addTarget(self, action: #selector(doneButtonPressed(_ :)), for: UIControlEvents.touchUpInside)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
//        dateFormat = "yyyy-MM-dd HH:mm"
        dateTextField.text = formatter.string(from: date)
        
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        //save new recurring task  
        //ViewControllerRouter(self).showUpcoming()
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
    }
    
    func doneButtonPressed(_ sender:UIButton)
    {
        //animate?
        recurrenceTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    func addMediaImageViewTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addMediaImageView.contentMode = .scaleAspectFit
            addMediaImageView.image = pickedImage
        }
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
        //TODO: update in future to query db for other group members
        
        //make three sample users
        let userNames = ["Dave", "Ali", "Callum"]
        
        for item in userNames {
            var user = User.init(id: "test01-id", token: "test01-token", username: "test01-username", timestamp: Date())
            user.firstName = item
            user.lastName = "lastName"
            user.userImage = #imageLiteral(resourceName: "Person_Dark")
            arrayOfUsers.append(user)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //visually "select" a group member
    }
    
}
