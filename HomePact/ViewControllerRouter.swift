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
    
    
    // MARK: - View Controller initializers -
    
    fileprivate func loginVC() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        
        return controller
    }
    
    fileprivate func registerVC() -> RegisterViewController {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        
        return controller
    }
    
    fileprivate func joinHomeVC() -> JoinHomeViewController {
        let storyboard = UIStoryboard(name: "JoinHome", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "JoinHome") as! JoinHomeViewController
        
        return controller
    }
    
    fileprivate func makeHomeVC() -> MakeHomeViewController {
        let storyboard = UIStoryboard(name: "MakeHome", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MakeHome") as! MakeHomeViewController
        
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
    // MARK: - Private functions -
    
    fileprivate func show(_ vc: UIViewController) {
        controller?.show(vc, sender: controller)
    }
}
