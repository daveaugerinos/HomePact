//
//  ViewControllerRouter.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-28.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class ViewControllerRouter: NSObject {

    // MARK: - Private variables -
    
    fileprivate var controller: UIViewController?
    
    // MARK: - Initializer -
    
    required init(_ controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: - Navigation functions -
    
    func popToRootVC() {
        let _ = controller?.navigationController?.popToRootViewController(animated: true)
    }
    
    func popVC() {
        let _ = controller?.navigationController?.popViewController(animated: true)
    }
    
    func showLogin() {
        show(loginVC())
    }
    
    func showRegister() {
        show(registerVC())
    }
    
    func showJoinHome() {
        show(joinHomeVC())
    }
    
    func showMakeHome() {
        show(makeHomeVC())
    }
    
    func showTasks() {
        show(taskPageVCs())
    }
    
    func showProfiles() {
        show(profilePageVCs())
    }
    
    func showAddOrModify() {
        show(addOrModifyVC())
    }
    
    func showCompleteTask() {
        show(completeTaskVC())
    }
    
    func showRootTabBar() {
        show(rootTabBar())
    }
    
    // MARK: - View Controller initializers -
    
    fileprivate func loginVC() -> LoginViewController {
        let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        
        return controller
    }
    
    fileprivate func registerVC() -> RegisterViewController {
        let controller = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        
        return controller
    }
    
    fileprivate func joinHomeVC() -> JoinHomeViewController {
        let controller = UIStoryboard(name: "JoinHome", bundle: nil).instantiateViewController(withIdentifier: "JoinHome") as! JoinHomeViewController
        
        return controller
    }
    
    fileprivate func makeHomeVC() -> MakeHomeViewController {
        let controller = UIStoryboard(name: "MakeHome", bundle: nil).instantiateViewController(withIdentifier: "MakeHome") as! MakeHomeViewController
        
        return controller
    }
    
    fileprivate func taskPageVCs() -> PageViewController {
        let tabPageVC = UIStoryboard(name: "Tasks", bundle: .main).instantiateViewController(withIdentifier: "tabPage") as! PageViewController
        tabPageVC.configureTab(with: .tasks)
        
        return tabPageVC
    }
    
    fileprivate func profilePageVCs() -> PageViewController {
        let tabPageVC = UIStoryboard(name: "Tasks", bundle: .main).instantiateViewController(withIdentifier: "tabPage") as! PageViewController
        tabPageVC.configureTab(with: .profiles)
       
        return tabPageVC
    }
    
    fileprivate func addOrModifyVC() -> AddOrModifyVC {
        
        return UIStoryboard(name: "AddOrModify", bundle: .main).instantiateViewController(withIdentifier: "addOrModify") as! AddOrModifyVC
    }
    
    fileprivate func completeTaskVC() -> CompleteTaskViewController{
        
        return UIStoryboard(name: "CompleteTask", bundle: .main).instantiateViewController(withIdentifier: "complete") as! CompleteTaskViewController
    }
    
    fileprivate func rootTabBar() -> RootTabBarController {
        return UIStoryboard(name: "RootTabBar", bundle: .main).instantiateInitialViewController() as! RootTabBarController
    }
    
    // MARK: - Show function -
    
    fileprivate func show(_ vc: UIViewController) {
        controller?.show(vc, sender: controller)
    }
}
