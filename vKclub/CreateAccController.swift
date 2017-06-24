//
//  CreateAccController.swift
//  vKclub
//
//  Created by HuySophanna on 31/5/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateAccController: ViewController {
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIComponentHelper.MakeBtnWhiteBorder(button: signUpBtn)
        UIComponentHelper.MakeBtnWhiteBorder(button: backBtn)
        
        UIComponentHelper.MakeWhitePlaceholderTextField(textfield: nameTextField, name: "Name")
        UIComponentHelper.MakeWhitePlaceholderTextField(textfield: emailTextField, name: "Email")
        UIComponentHelper.MakeWhitePlaceholderTextField(textfield: passwordTextField, name: "Password")
        UIComponentHelper.MakeWhitePlaceholderTextField(textfield: confirmTextField, name: "Confirm Password")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SignUpClicked(_ sender: Any) {
        if (nameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmTextField.text?.isEmpty)! {
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
        } else {
            //show loading activity indicator
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                //successfully created, done loading activity indicator
                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                
                if (error == nil) {
                    self.PresentAlertController(title: "Success", message: "Your new account has been created. Try logging in 🤠", actionTitle: "Okay")
                } else {
                    self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                }
            }
        }
    }
    
    
    @IBAction func BackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
