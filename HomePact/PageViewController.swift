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
    
    enum ConfigureOptions  { case
        profiles,
        tasks
    }

    @IBOutlet weak var statusBarView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func configureTab(with configureOption: ConfigureOptions) {
        let storyboard = UIStoryboard(name: "Tasks", bundle: .main)
        
        switch configureOption {
        case .profiles:
            let upcomingTaskVC = storyboard.instantiateViewController(withIdentifier: "upcomingTasks") as! UpcomingTaskTVC
            let completedTaskVC = storyboard.instantiateViewController(withIdentifier: "completedTasks") as! CompletedTaskTVC
            setup(with: [upcomingTaskVC,completedTaskVC])
        case .tasks:
            let myProfileVC = storyboard.instantiateViewController(withIdentifier: "") as! UpcomingTaskTVC
            let groupProfileVC = storyboard.instantiateViewController(withIdentifier: "") as! CompletedTaskTVC
            setup(with: [myProfileVC,groupProfileVC])
            
        }
    }
    
    fileprivate func setup(with viewControllers:[UIViewController]){
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
