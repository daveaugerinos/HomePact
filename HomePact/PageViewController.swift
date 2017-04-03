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
   
    enum ConfigureOptions  { case profiles, tasks }
   
    @IBOutlet weak var statusBarView: UIView!
    var swipeLeft:UIScreenEdgePanGestureRecognizer!
    var swipeRight:UIScreenEdgePanGestureRecognizer!
    var tabPage:TabPageViewController!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTab(with: .tasks)
        
        swipeLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeLeft.edges = .right
        swipeRight.edges = .left
        swipeLeft.delegate = self
        swipeRight.delegate = self
        tabPage.view.addGestureRecognizer(swipeLeft)
        tabPage.view.addGestureRecognizer(swipeRight)
        
        // Do any additional setup after loading the view.
        
    }
    

    func configureTab(with configureOption: ConfigureOptions) {
        let tasksStoryboard = UIStoryboard(name: "Tasks", bundle: .main)
        
        switch configureOption {
        case .tasks:
            let upcomingTaskVC = tasksStoryboard.instantiateViewController(withIdentifier: "upcomingTasks") as! UpcomingTaskTVC
            let completedTaskVC = tasksStoryboard.instantiateViewController(withIdentifier: "completedTasks") as! CompletedTaskTVC
            setup(with: [upcomingTaskVC,completedTaskVC])
        case .profiles:
            let myProfileVC =  UIStoryboard(name: "ProfilesPersonal", bundle: .main)
.instantiateViewController(withIdentifier: "profilesPersonal") as! ProfilesPersonalViewController
            let groupProfileVC =  UIStoryboard(name: "ProfilesGroup", bundle: .main)
.instantiateViewController(withIdentifier: "profilesGroup") as! ProfilesGroupViewController
            setup(with: [myProfileVC,groupProfileVC])
            
        }
    }
    
    
    fileprivate func setup(with viewControllers:[UIViewController]){
        tabPage = TabPageViewController.create()
        print("\(tabPage.gestureRecognizers)")
        for vc in viewControllers{
            tabPage.tabItems.append((vc, vc.title!))
        }
        var option = TabPageOption()
        option.currentColor = UIColor.white
        option.defaultColor = UIColor.white
        option.tabWidth = view.frame.width/2
        option.tabMargin = 30.0
        option.tabBackgroundColor = #colorLiteral(red: 0.8508874774, green: 0.8510339856, blue: 0.8508781791, alpha: 1)
        option.isTranslucent = false
        tabPage.option = option
        
        addChildViewController(tabPage)
        view.addSubview(tabPage.view)
        view.addSubview(statusBarView)

        view.setNeedsDisplay()
    }
    
    func swipedLeft() {
     tabPage.resignFirstResponder()
    }
    
    func swipedRight() {
        tabPage.resignFirstResponder()
    }


}

extension PageViewController:UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        tabPage.resignFirstResponder()
        return true
    }
    
}
