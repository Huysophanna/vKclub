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
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: emailTextField, name: "Email", color: UIColor.white)
    }
    @IBAction func RecoverBtnClicked(_ sender: Any) { 
        InternetConnection.second = 0
        InternetConnection.countTimer.invalidate()
        if (emailTextField.text?.isEmpty)!{
            
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
            return 
        }
        
        Auth.auth().fetchProviders(forEmail: emailTextField.text!) { (accData, error) in
            if error == nil{
                if accData == nil {
                    self.PresentAlertController(title: "Something went wrong", message: "The email you entered did not match our records. Please double-check and try again.", actionTitle: "Got it")
                    return
                    
                }
                for i in accData!{
                    if i == "facebook.com"{
                        self.PresentAlertController(title: "Something went wrong", message: "Your account is linked with Facebook. Please Sign in with Facebook instead to move on.", actionTitle: "Got it")
                        return
                    }
                }
                
            } else {
                self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                return
            }
        }
        InternetConnection.CountTimer()
        Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!) { (error) in
            if InternetConnection.second == 10 {
                
                InternetConnection.countTimer.invalidate()
                InternetConnection.second = 0
                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                return
            }
            if error == nil {
                
                self.PresentAlertController(title: "Success", message: "Please check your email to recover your password", actionTitle: "Got it")
                UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
            } else {
                self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
            }
            
        }
    }
    @IBAction func BackBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
