//
//  AddOrModifyVC.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class AddOrModifyVC: UIViewController {

    @IBOutlet weak fileprivate var topFakeNavBarView: UIView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var cancelButton: UIButton!
    
    
    @IBOutlet weak fileprivate var taskNameTextField: UITextField!
    @IBOutlet weak fileprivate var dateTextField: UITextField!
    @IBOutlet weak fileprivate var recurrenceTextField: UITextField!
    
    @IBOutlet weak fileprivate var groupMembersCollectionView: UICollectionView!
    
    @IBOutlet weak fileprivate var repeatDetailsView: UIView!
    @IBOutlet weak fileprivate var repeatSlider: UISlider!
    @IBOutlet weak fileprivate var repeatNumberOfTimesLabel: UILabel!
    
    @IBOutlet weak fileprivate var addMediaImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enable interaction of dateTextField -> datePicker
        //enable interaction of recurrenceTextField -> PickerController
        //set repeatDetailsView frame height to zero
        //enable interaction of addMediaImageView - ImagePickerController etc
        //configure groupMembersCollectionView dataSource
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        //segue back to upcoming tasks
    }

    @IBAction func completeButtonPressed(_ sender: UIButton) {
        //segue back to upcoming tasks with new task
    }
    

}
