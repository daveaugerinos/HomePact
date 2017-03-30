//
//  AddOrModifyVC.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class AddOrModifyVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak fileprivate var topFakeNavBarView: UIView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var cancelButton: UIButton!
    
    @IBOutlet weak fileprivate var taskNameTextField: UITextField!
    @IBOutlet weak fileprivate var dateLabel: UILabel!
    @IBOutlet weak fileprivate var recurrenceLabel: UILabel!
    
    @IBOutlet weak fileprivate var groupMembersCollectionView: UICollectionView!
    
    @IBOutlet weak var repeatDetailsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var repeatDetailsView: UIView!
    @IBOutlet weak fileprivate var repeatSlider: UISlider!
    @IBOutlet weak fileprivate var repeatNumberOfTimesLabel: UILabel!
    
    @IBOutlet weak fileprivate var addMediaImageView: UIImageView!
    
    let datepickerView = UIDatePicker()
    let recurrencePickerView = UIPickerView()
    let arrayOfRecurrences = ["Once-off", "Weekly", "Fortnightly", "Monthly", "Quarterly", "Yearly"]
    var arrayOfUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDatePicker(_:))))
        
        recurrenceLabel.isUserInteractionEnabled = true
//        repeatDetailsView.frame.height = 0
//        repeatDetailsViewHeightConstraint.constant = 0
//        repeatDetailsView.translatesAutoresizingMaskIntoConstraints = true
        
        addMediaImageView.isUserInteractionEnabled = true
        addMediaImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addMediaImageViewTapped(_:))))
        
        configureDataSource()
    }
    
    //MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        //segue back to upcoming tasks
    }

    @IBAction func completeButtonPressed(_ sender: UIButton) {
        //segue back to upcoming tasks with new task
    }
    
    //MARK: Show Picker Methods
    
    func showDatePicker(_ sender: UITapGestureRecognizer) {
        //change height?
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
        //show repeatDetailsView if not one-off
    }
    
    //MARK: UIPickerView DataSource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfRecurrences.count
    }
    
    //MARK: Collection View Methods
    
    func configureDataSource() {
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
