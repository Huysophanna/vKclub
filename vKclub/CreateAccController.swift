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
        
        MakeBtnBorder(button: signUpBtn)
        MakeBtnBorder(button: backBtn)
        
        MakeWhitePlaceholder(textfield: nameTextField, name: "Name")
        MakeWhitePlaceholder(textfield: emailTextField, name: "Email")
        MakeWhitePlaceholder(textfield: passwordTextField, name: "Password")
        MakeWhitePlaceholder(textfield: confirmTextField, name: "Confirm Password")
        
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
    
    func MakeBtnBorder(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        button.layer.cornerRadius = 8
        
    }
    
    func MakeWhitePlaceholder(textfield: UITextField, name: String) {
        textfield.attributedPlaceholder = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: UIColor.white])
       
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
