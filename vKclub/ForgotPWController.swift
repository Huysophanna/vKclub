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

class ForgotPWController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        UIComponentHelper.MakeBtnWhiteBorder(button: signUpBtn, color: UIColor.white)
        UIComponentHelper.MakeBtnWhiteBorder(button: backBtn, color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: emailTextField, name: "Email", color: UIColor.white)
        emailTextField.delegate = self
        
    }
    @IBAction func RecoverBtnClicked(_ sender: Any) {
        InternetConnection.second = 0
        InternetConnection.countTimer.invalidate()
        if (emailTextField.text?.isEmpty)!{
            
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
            return 
        } else {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
            Auth.auth().fetchProviders(forEmail: emailTextField.text!) { (accData, error) in
                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                if error == nil{
                    if accData == nil {
                        self.PresentAlertController(title: "Something went wrong", message: "The email you entered did not match our records. Please double-check and try again.", actionTitle: "Got it")
                        return
                        }
                    for i in accData!{
                        if i == "facebook.com"{
                            self.PresentAlertController(title: "Something went wrong", message: "Your account is linked with Facebook. Please Sign in with Facebook instead to move on.", actionTitle: "Got it")
                            return
                            
                        } else {
                            InternetConnection.CountTimer()
                            
                            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!) { (error) in
                                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                                if InternetConnection.second == 15 {
                                    InternetConnection.countTimer.invalidate()
                                    InternetConnection.second = 0
                                    UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                                    return
                                }
                                InternetConnection.countTimer.invalidate()
                                InternetConnection.second = 0
                                if error == nil {
                                    self.PresentAlertController(title: "Success", message: "Please check your email to recover your password", actionTitle: "Got it")
                                    UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
                                } else {
                                    self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                }
                                
                            }
                            
                        }
                    }
                    
                } else {
                    self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                }
            }

            
        }
        
        
    }
    @IBAction func BackBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        RecoverBtnClicked(self)
        return true
    }

    
}
