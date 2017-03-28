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
    
    // MARK: - View Controller initializers -
    
    fileprivate func loginVC() -> LoginViewController {
        return LoginViewController()
    }
    
    fileprivate func registerVC() -> RegisterViewController {
        return RegisterViewController()
    }
    
    fileprivate func joinHomeVC() -> JoinHomeViewController {
        return JoinHomeViewController()
    }
    
    fileprivate func makeHomeVC() -> MakeHomeViewController {
        return MakeHomeViewController()
    }
    
    
    // MARK: - Private functions -
    
    fileprivate func show(_ vc: UIViewController) {
        controller?.show(vc, sender: controller)
    }
}
