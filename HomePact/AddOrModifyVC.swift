//
//  AddOrModifyVC.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class AddOrModifyVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var topFakeNavBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var recurrenceTextField: UITextField!
    
    @IBOutlet weak var groupMembersCollectionView: UICollectionView!
    
    @IBOutlet weak var repeatDetailsView: UIView!
    @IBOutlet weak var repeatSlider: UISlider!
    @IBOutlet weak var repeatNumberOfTimesLabel: UILabel!
    
    @IBOutlet weak var addMediaImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enable interaction of dateTextField -> datePicker
        //enable interaction of recurrenceTextField -> PickerController
        //set repeatDetailsView frame height to zero
        //enable interaction of addMediaImageView - ImagePickerController etc
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }

    @IBAction func completeButtonPressed(_ sender: UIButton) {
    }
    

}
