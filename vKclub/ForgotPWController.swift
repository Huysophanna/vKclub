//
//  ForgotPWController.swift
//  vKclub
//
//  Created by HuySophanna on 2/6/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPWController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIComponentHelper.MakeBtnWhiteBorder(button: signUpBtn, color: UIColor.white)
        UIComponentHelper.MakeBtnWhiteBorder(button: backBtn, color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: emailTextField, name: "Name", color: UIColor.white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func RecoverBtnClicked(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error == nil {
                self.PresentAlertController(title: "Success", message: "Please check your email to recover your password", actionTitle: "Got it")
            } else {
                self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
            }
            
        }
    }
    
    @IBAction func BackBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
