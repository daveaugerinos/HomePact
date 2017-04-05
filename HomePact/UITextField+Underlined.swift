//
//  UITextField+Underlined.swift
//  HomePact
//
//  Created by Callum Davies on 2017-03-30.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
