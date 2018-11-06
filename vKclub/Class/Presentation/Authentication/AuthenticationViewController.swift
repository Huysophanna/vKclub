//
//  AuthenticationViewController.swift
//  vKclub
//
//  Created by Machintos-HD on 11/6/18.
//  Copyright © 2018 WiAdvance. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog

class AuthenticationViewController: UIViewController {

    
    

}

extension AuthenticationViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if Auth.auth().currentUser == nil {
            self.presentDialogForLogin(message: "asdf")
        } else {
            
            print("d")
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Pop up
extension AuthenticationViewController {
    /// Present dialog to alert user to login in order to access that particular tabbar items
    func presentDialogForLogin (message: String) {
        
//        CustomPopupDialogView()
        
//        print("You have click on \(clickTab)")
        
        let dialog = PopupDialog(title: message, message: message)
//        let dialogAlert = PopupDialog(title: "Warning", message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .bounceUp, preferredWidth: view.frame.width / 1.3, tapGestureDismissal: false, panGestureDismissal: false, hideStatusBar: false) {
//            print("Done showing")
//
//        }
        
        let okayButton = DefaultButton(title: "Login") {
            let view = LoginViewController()
            let navigationController = View.setupNavigationViewController(viewController: view)
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        }
        let cancelButton = CancelButton(title: "Cancel") {
            
        }
        dialog.addButtons([okayButton, cancelButton])
        
        self.present(dialog, animated: true, completion: nil)
    }
}
