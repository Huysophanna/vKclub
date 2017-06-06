//
//  LoginController.swift
//  vKclub
//
//  Created by HuySophanna on 30/5/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInFBBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MakeLeftViewIconToTextField(textField: emailTextField, icon: "user_left_icon.png")
        MakeLeftViewIconToTextField(textField: pwTextField, icon: "pw_icon.png")
        
        MakeBorderTransparentBtn(button: signInBtn)
        MakeFBBorderBtn(button: signInFBBtn)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SignInClicked(_ sender: Any) {
        if emailTextField.text == "" || pwTextField.text == "" {
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
            
        } else {
            //handle firebase sign in
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                
                if error == nil {
                    self.PresentAlertController(title: "Success", message: "😁 Logged In!", actionTitle: "Done")
                } else {
                    self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                }
                
            }
        }
    }
    
    @IBAction func CreateAccount(_ sender: Any) {
        performSegue(withIdentifier: "SegueToCreateAcc", sender: self)
    }
    
    @IBAction func ForgotPWClicked(_ sender: Any) {
        performSegue(withIdentifier: "SegueToForgotPW", sender: self)
    }
    
    func MakeBorderTransparentBtn(button: UIButton) {
        
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        button.layer.cornerRadius = 5
    }
    
    func MakeFBBorderBtn(button: UIButton) {
        button.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0).cgColor
        button.layer.cornerRadius = 5
    }
    
    func MakeLeftViewIconToTextField(textField: UITextField, icon: String) {
        let imageView = UIImageView();
        let image = UIImage(named: icon);
        imageView.image = image;
        imageView.frame = CGRect(x: 18, y: 15, width: 20, height: 20)
        textField.addSubview(imageView)
        let leftView = UIView.init(frame: CGRect(x: 10, y: 10, width: 45, height: 25))
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewMode.always

    }
  
}
