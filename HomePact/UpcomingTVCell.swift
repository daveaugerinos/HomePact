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
    
    @IBOutlet weak fileprivate var taskImageView: UIImageView!
    @IBOutlet weak fileprivate var userImageViewOne: UIImageView!
    @IBOutlet weak fileprivate var userImageViewTwo: UIImageView!
    @IBOutlet weak fileprivate var userImageViewThree: UIImageView!
    
    @IBOutlet weak fileprivate var taskNameLabel: UILabel!
    @IBOutlet weak fileprivate var taskDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func configureCell() {
        
        taskNameLabel.text = "Test"
        taskDateLabel.text = "\(Date())"
        taskImageView.image = UIImage(named: "Person_Dark")
        userImageViewOne.image = UIImage(named: "Person_Dark")
        userImageViewTwo.image = UIImage(named: "Person_Dark")
        userImageViewThree.image = UIImage(named: "Person_Dark")
        userImageViewOne.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        userImageViewTwo.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        userImageViewThree.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)

        roundViews()
        
    }
    
    fileprivate func roundViews() {
        round(viewArray:[taskImageContainerView, userImageViewOne, userImageViewTwo, userImageViewThree] )
    }
    
    fileprivate func round(viewArray:[UIView]){
       
        for view in viewArray{
            
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = view.frame.width/2
        }
    }
}
