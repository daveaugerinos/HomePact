//
//  CompletedTVCell.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import SwipeCellKit

class CompletedTVCell: SwipeTableViewCell {

    
    @IBOutlet weak fileprivate var completedTaskImageView: UIImageView!
    @IBOutlet weak fileprivate var completedUserImageView: UIImageView!
    
    @IBOutlet weak fileprivate var completedTaskNameLabel: UILabel!
    @IBOutlet weak fileprivate var completionDateLabel: UILabel!
    @IBOutlet weak fileprivate var lastTaskMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    fileprivate func configureCell() {
        completedUserImageView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        completedTaskImageView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        completedTaskNameLabel.text = "test task"
        completionDateLabel.text =  "\(Date())"
        lastTaskMessageLabel.text = "woo done task"
        
        roundViews()
    }
    
    fileprivate func roundViews() {
        round(viewArray:[completedTaskImageView,completedUserImageView] )
    }
    
    fileprivate func round(viewArray:[UIView]){
        
        for view in viewArray{
            
            view.layer.borderWidth = 3.0
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.cornerRadius = view.frame.width/2
        }
    }

}
