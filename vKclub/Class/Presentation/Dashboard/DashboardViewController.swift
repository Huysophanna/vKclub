//
//  DashboardViewController.swift
//  vKclub
//
//  Created by Machintos-HD on 11/1/18.
//  Copyright © 2018 vKirirom.com. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog

// class variables
class DashboardViewController: UIViewController ,UITabBarControllerDelegate {

    

}

// APP Life cycle
extension DashboardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController == tabBarController.viewControllers![1] {
            
            if Auth.auth().currentUser == nil {
                print("User is not logged in yet")
                self.presentDialog()
                return false
            } else {
                return true
            }
            
        } else {
            return true
        }

    }
    func presentDialog() {
        let dialog = PopupDialog(title: "Warning", message: "Please login to continue")
        let okayButton = DefaultButton(title: "Okay") {
            let login = UINavigationController(rootViewController: LoginViewController())
            self.present(login, animated: true, completion: nil)
            print("User click okay")
        }
        let cancel = CancelButton(title: "Cancel", action: nil)
        dialog.addButtons([okayButton, cancel])
        self.present(dialog, animated: true, completion: nil)
    }
}
