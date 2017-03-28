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
        let upcomingTaskVC = UIStoryboard.init(name: "Tasks", bundle: Bundle.main).instantiateViewController(withIdentifier: "upcomingTasks")
        let completedTaskVC = UIStoryboard.init(name: "Tasks", bundle: Bundle.main).instantiateViewController(withIdentifier: "completedTasks")
        setupWith(vcArray: [upcomingTaskVC,completedTaskVC])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWith(vcArray:[UIViewController]){
        let tabPageVC = TabPageViewController.create()
        
        for vc in vcArray{
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
