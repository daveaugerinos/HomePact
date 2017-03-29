//
//  PageViewController.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import TabPageViewController

class PageViewController: UIViewController {

    @IBOutlet weak var statusBarView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func setup(with viewControllers:[UIViewController]){
        let tabPageVC = TabPageViewController.create()
        
        for vc in viewControllers{
            tabPageVC.tabItems.append((vc, vc.title!))
        }
        
        var option = TabPageOption()
        option.currentColor = UIColor.white
        option.defaultColor = UIColor.white
        option.tabWidth = view.frame.width/2
        option.tabMargin = 30.0
        option.tabBackgroundColor = #colorLiteral(red: 0.8508874774, green: 0.8510339856, blue: 0.8508781791, alpha: 1)
        option.isTranslucent = false
        tabPageVC.option = option
        
        addChildViewController(tabPageVC)
        view.addSubview(tabPageVC.view)
        view.addSubview(statusBarView)

        view.setNeedsDisplay()
    }


}
