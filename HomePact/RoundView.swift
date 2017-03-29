//
//  RoundView.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-29.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

@IBDesignable

class RoundView: UIView {

    var imageView: UIImageView!
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var backgroundColour: UIColor = UIColor.clear {
        didSet {
            imageView.backgroundColor = backgroundColour
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 2 {
        didSet {
            layer.cornerRadius = frame.size.height/cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColour: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColour.cgColor
        }
    }
    
    @IBInspectable var clipToBounds: Bool = true {
        didSet {
            clipsToBounds = clipToBounds
        }
    }
    
    @IBInspectable var maskToBounds: Bool = true {
        didSet {
            layer.masksToBounds = maskToBounds
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    func addSubviews() {
        imageView = UIImageView()
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height/cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColour.cgColor
        clipsToBounds = clipToBounds
        layer.masksToBounds = maskToBounds
        imageView.frame = self.bounds
        imageView.contentMode = UIViewContentMode.scaleAspectFit
    }
}
