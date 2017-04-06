//
//  RootTabBarController.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-29.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    fileprivate let buttonDiameter = CGFloat(60)
    fileprivate var showActionsActive = false
    fileprivate var showActions: UIButton!
    fileprivate var addTask: UIButton!
    fileprivate var completeTask: UIButton!
    fileprivate var addTaskActiveCenter: CGPoint!
    fileprivate var completeTaskActiveCenter: CGPoint!
    private var rotationAngle: Double = 0
    fileprivate var blurView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let profilesPageView = createProfilesPageView()
        let tasksPageView = createTasksPageView()
        let profilesNav = createNavigationController(for: profilesPageView)
        let tasksNav = createNavigationController(for: tasksPageView)
        self.setViewControllers([tasksNav, profilesNav], animated: false)
        
        tasksPageView.tabBarItem = UITabBarItem(title: "Tasks", image: #imageLiteral(resourceName: "Magical Scroll") , selectedImage: #imageLiteral(resourceName: "Magical Scroll Filled"))
        profilesPageView.tabBarItem = UITabBarItem(title: "Profiles", image:#imageLiteral(resourceName: "User Groups"), selectedImage: #imageLiteral(resourceName: "User Groups Filled"))
        tabBar.tintColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        setupButtons()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if showActionsActive == true {
            animateButtons()
        }
    }
    
    fileprivate func createNavigationController(for viewController: PageViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.isHidden = true
        //further implementation if necessary
        return navController
    }
    
    fileprivate func createProfilesPageView() -> PageViewController {
        
        let profiles = UIStoryboard(name: "TabPageView", bundle: .main).instantiateViewController(withIdentifier: "tabPage") as! PageViewController
        profiles.configureTab(with: .profiles)
        profiles.title = "Profiles"
        
        return profiles
        
    }

    fileprivate func createTasksPageView() -> PageViewController {
     
        let tasks = UIStoryboard(name: "TabPageView", bundle: .main).instantiateViewController(withIdentifier: "tabPage") as! PageViewController
        tasks.configureTab(with: .tasks)
        tasks.title = "Tasks"
        
        return tasks
    }
    
    fileprivate func setupButtons() {
        
        setupActionButtons()
        setupShowActionsButton()
        
    }
    
    fileprivate func setupShowActionsButton() {
        showActions = makeButton(with: buttonDiameter)
        showActions.layer.cornerRadius = buttonDiameter/2
        //showActions.backgroundColor = .black
        showActions.setBackgroundImage(#imageLiteral(resourceName: "Plus_Button_Up"), for: .normal)
        showActions.setBackgroundImage(#imageLiteral(resourceName: "Plus_Button_Down"), for: .highlighted)
        showActions.addTarget(self, action: #selector(showActionsTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(showActions)
    }
    
    
    fileprivate func setupActionButtons() {
        addTask = makeButton(with: buttonDiameter)
        completeTask = makeButton(with: buttonDiameter)
        
        addTask.layer.cornerRadius = buttonDiameter/2
        addTask.setBackgroundImage(#imageLiteral(resourceName: "Add Task"), for: .normal)
        addTask.addTarget(self, action: #selector(addTaskTapped(sender:)), for: .touchUpInside)
        addTaskActiveCenter = CGPoint(x: addTask.center.x - 100, y: addTask.center.y - 100)
            
        completeTask.layer.cornerRadius = buttonDiameter/2
        completeTask.setBackgroundImage(#imageLiteral(resourceName: "Complete Task"), for: .normal)
        completeTask.addTarget(self, action: #selector(completeTaskTapped(sender:)), for: .touchUpInside)
        completeTaskActiveCenter = CGPoint(x: completeTask.center.x + 100, y: completeTask.center.y - 100)
        
        self.view.addSubview(addTask)
        self.view.addSubview(completeTask)
    }
    
    fileprivate func makeButton(with diameter:CGFloat) -> UIButton {
    
      return UIButton(frame: CGRect(x: self.view.frame.width/2-diameter/2, y: self.view.frame.height-diameter, width: diameter, height: diameter))
    }
    
    
    fileprivate func toggleShowActions()  {
        showActionsActive = !showActionsActive
    }
    
    
    func showActionsTapped(sender: UIButton) {
        
        animateButtons()
    }
    
    func animateButtons() {
        if showActionsActive == false {
            
            rotationAngle = M_PI_4
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.addTask.center = self.addTaskActiveCenter
                self.completeTask.center = self.completeTaskActiveCenter
                
                self.showActions.setBackgroundImage(#imageLiteral(resourceName: "Plus_Button_Down"), for: .normal)
                self.showActions.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotationAngle))
                
            }, completion: nil)
            blurBackgroud()
            
            self.toggleShowActions()
            
        } else {
            
            rotationAngle = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.addTask.center = self.showActions.center
                self.completeTask.center = self.showActions.center
                
                self.showActions.setBackgroundImage(#imageLiteral(resourceName: "Plus_Button_Up"), for: .normal)
                
                self.showActions.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotationAngle))
                
            }, completion: nil)
            blurBackgroud()
            
            self.toggleShowActions()
        }
    }
    
    func blurBackgroud() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if showActionsActive == false {
            blurView = blurEffectView
            view.insertSubview(blurView, belowSubview: tabBar)
        }else{
            blurView.removeFromSuperview()
        }

        
    }
    func addTaskTapped(sender: UIButton)  {
        ViewControllerRouter(self).presentAddTask()
    }
    
    func completeTaskTapped(sender: UIButton) {
        ViewControllerRouter(self).presentCompleteTask()
    }
}

