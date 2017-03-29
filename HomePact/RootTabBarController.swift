//
//  RootTabBarController.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-03-29.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let profilesPageView = createProfilesPageView()
        let tasksPageView = createTasksPageView()
        let profilesNav = createNavigationController(for: profilesPageView)
        let tasksNav = createNavigationController(for: tasksPageView)
        
        self.viewControllers = [tasksNav, profilesNav]
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
        tasks.title = "Title"
        
        return tasks
    }
}

