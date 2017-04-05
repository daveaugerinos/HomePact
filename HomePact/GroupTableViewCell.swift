//
//  GroupTableViewCell.swift
//  HomePact
//
//  Created by Callum Davies on 2017-04-05.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupTVCellUserNameLabel: UILabel!
    @IBOutlet weak var groupTVCellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var user: User! {
        didSet {
            configureCell()
        }
    }
    
    fileprivate func configureCell() {
        groupTVCellUserNameLabel.text = user.firstName
        groupTVCellImageView.image = user.userImage
    }
    

}
