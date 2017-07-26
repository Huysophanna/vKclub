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
        
        
        UIComponentHelper.MakeBtnWhiteBorder(button: signUpBtn, color: UIColor.white)
        UIComponentHelper.MakeBtnWhiteBorder(button: backBtn, color: UIColor.white)
        
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: nameTextField, name: "Name", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: emailTextField, name: "Email", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: passwordTextField, name: "Password", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: confirmTextField, name: "Confirm Password", color: UIColor.white)
        
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
                    let changeRequest = user?.createProfileChangeRequest()
                    changeRequest?.displayName = self.nameTextField.text
                    changeRequest?.commitChanges { (error) in
                    
                    }
                    user?.sendEmailVerification(completion: { (error) in
                        if error != nil{
                            self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        }
                     })
                     
                    self.PresentAlertController(title: "Success", message: "Please verify your account with the link we have sent to your email address.", actionTitle: "Okay")
                  
                    UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")

                    
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
