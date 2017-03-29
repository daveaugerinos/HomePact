//
//  AddOrModifyCVCell.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-29.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class AddOrModifyCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var user: User! {
        didSet {
            configureCell()
        }
    }
    
    fileprivate func configureCell() {
        label.text = user.firstName
        imageView.image = user.userImage
        roundViews()
    }
    
    fileprivate func roundViews() {
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
}
