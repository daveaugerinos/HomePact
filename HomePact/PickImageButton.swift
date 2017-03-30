//
//  PickImageButton.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-29.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

@IBDesignable

class PickImageButton: UIButton {
    
    @IBInspectable var fillColour: UIColor = UIColor.clear
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColour: UIColor = UIColor.clear
    @IBInspectable var clipToBounds: Bool = true
    @IBInspectable var maskToBounds: Bool = true
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColour.setFill()
        path.fill()
        layer.cornerRadius = frame.size.height/cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColour.cgColor
        clipsToBounds = clipToBounds
        layer.masksToBounds = maskToBounds
    }
}
