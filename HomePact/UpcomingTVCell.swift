//
//  UpcomingTVCell.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class UpcomingTVCell: UITableViewCell {

    @IBOutlet weak fileprivate var userImageContainerView: UIView!
    @IBOutlet weak fileprivate var taskImageContainerView: UIView!
    
    @IBOutlet weak fileprivate var userImageViewOne: UIImageView!
    @IBOutlet weak fileprivate var userImageViewTwo: UIImageView!
    @IBOutlet weak fileprivate var userImageViewThree: UIImageView!
    
    @IBOutlet weak fileprivate var taskNameLabel: UILabel!
    @IBOutlet weak fileprivate var taskDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
