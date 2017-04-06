//
//  UpcomingTVCell.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import SwipeCellKit

class UpcomingTVCell: SwipeTableViewCell {

    @IBOutlet weak fileprivate var userImageContainerView: UIView!
    @IBOutlet weak fileprivate var taskImageContainerView: RoundView!
    
    @IBOutlet weak var userOneRoundView: RoundView!
    @IBOutlet weak var userTwoRoundView: RoundView!
    @IBOutlet weak var userThreeRoundView: RoundView!
    
    
    @IBOutlet weak fileprivate var userImageViewOne: RoundView!
    @IBOutlet weak fileprivate var userImageViewTwo: RoundView!
    @IBOutlet weak fileprivate var userImageViewThree: RoundView!
    
    @IBOutlet weak fileprivate var taskNameLabel: UILabel!
    @IBOutlet weak fileprivate var taskDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ task:Task){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        
        guard let taskDate = task.taskDate else {
            return
        }
        guard let taskImage = task.taskImage else {
            return
        }
        
        
        taskNameLabel.text = task.name
        taskDateLabel.text = dateFormatter.string(from: taskDate)
        taskImageContainerView.image = taskImage
        
        userOneRoundView.image = UIImage(named: "Person_Dark")
        userTwoRoundView.image = UIImage(named: "Person_Dark")
        userThreeRoundView.image = UIImage(named: "Person_Dark")

        
    }
    

  }
