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

class CreateAccController: ViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let storageRef = Storage.storage().reference()
    var nameTage = 0;

    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        UIComponentHelper.MakeBtnWhiteBorder(button: signUpBtn, color: UIColor.white)
        UIComponentHelper.MakeBtnWhiteBorder(button: backBtn, color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: nameTextField, name: "Name", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: emailTextField, name: "Email", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: passwordTextField, name: "Password", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: confirmTextField, name: "Confirm Password", color: UIColor.white)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
    }
    @IBAction func SignUpClicked(_ sender: Any) {
        let length_password : Int = (passwordTextField.text?.characters.count)!
        let length_username : Int = (nameTextField.text?.characters.count)!
        let specialcharaters = UIComponentHelper.AvoidSpecialCharaters(specialcharaters: nameTextField.text!)
        let conutwhitespece : Int = UIComponentHelper.Countwhitespece(_whitespece:nameTextField.text!)
        if (nameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmTextField.text?.isEmpty)! {
            PresentAlertController(title: "Warning", message: "Please properly insert your data", actionTitle: "Got it")
            return
        }  else if confirmTextField.text !=  passwordTextField.text {
            PresentAlertController(title: "Warning", message: "Your password doesn't match with confirm password", actionTitle: "Got it")
             return
        } else if length_password < 6 {
            PresentAlertController(title: "Warning", message: "Pleaes enter your password more then 6 characters", actionTitle: "Got it")
            return
        } else if length_username < 5 {
            
            PresentAlertController(title: "Warning", message: "Pleaes enter your username more then 6 characters", actionTitle: "Got it")
            return
        } else if length_username > 20 {
            PresentAlertController(title: "Warning", message: "Pleaes enter your username less then 20 characters", actionTitle: "Got it")
            return
            
        } else if length_password > 20 {
            PresentAlertController(title: "Warning", message: "Pleaes enter your password less then 20 characters", actionTitle: "Got it")
            return
        } else if specialcharaters == false {
             PresentAlertController(title: "Warning", message: "Your username should not contant with special charaters or number", actionTitle: "Got it")
            return
        } else if conutwhitespece >= 3 {
            PresentAlertController(title: "Warning", message: "Your username should not contant more then 3 white spece", actionTitle: "Got it")
            return
        }
        else {
            let whitespeceatbeginning = UIComponentHelper.Whitespeceatbeginning(_whitespece: nameTextField.text!)
            if whitespeceatbeginning == true {
                 PresentAlertController(title: "Warning", message: "Your username should not contant white spece at beginning ", actionTitle: "Got it")
                return
            }

            InternetConnection.second = 0
            InternetConnection.countTimer.invalidate()
            //show loading activity indicator
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
            InternetConnection.CountTimer()
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                //successfully created, done loading activity indicator
                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                if InternetConnection.second == 10 {
                    
                    InternetConnection.countTimer.invalidate()
                    InternetConnection.second = 0
                    UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                    return
                }
                InternetConnection.countTimer.invalidate()
                InternetConnection.second = 0
                if (error == nil) {
                    let img = UIImage(named: "profile-icon")
                    let newImage = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 400, height: 400))
                    let imageProfiles = UIImagePNGRepresentation(newImage)
                    let riversRef =  self.storageRef.child("userprofile-photo").child((user?.uid)!)
                    
                    
                    riversRef.putData(imageProfiles! , metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            return
                        }
                    
                        let downloadURL = metadata.downloadURL()!.absoluteString
                        print(downloadURL)
                        let url = NSURL(string: downloadURL) as URL?
                        let chageProfileuser = user?.createProfileChangeRequest()
                        chageProfileuser?.photoURL =  url
                        chageProfileuser?.displayName = self.nameTextField.text
                        chageProfileuser?.commitChanges { (error) in
                            if error != nil {
                               self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                            }
                            
                        }
                    }
                   
                    user?.sendEmailVerification(completion: { (error) in
                        if error != nil{
                            self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        }
                     })
                     
                    self.PresentAlertController(title: "Success", message: "Please verify your account with the link we have sent to your email address.", actionTitle: "Okay")
                  
                    UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")

                    
                } else {
                    let check :String  = (error?.localizedDescription)!
                    switch check {
                    case "The email address is badly formatted.":
                         self.PresentAlertController(title: "Something went wrong", message: "Please provide a valid form of email address.", actionTitle: "Okay")
                        break
                    case "The email address is already in use by another account":
                         self.PresentAlertController(title: "Something went wrong", message: "The email address is already in use by another account", actionTitle: "Okay")
                        break
                    default:
                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        break
                        
                    }
                }
            }
        }
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        if (nameTextField.text?.isEmpty == false) || (emailTextField.text?.isEmpty == false) || (passwordTextField.text?.isEmpty == false) || (confirmTextField.text?.isEmpty == false) {
            let logoutAlert = UIAlertController(title: "Go back", message: "Are you sure to go back?", preferredStyle: UIAlertControllerStyle.alert)
            
            logoutAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                 self.dismiss(animated: true, completion: nil)
            }))
            logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present( logoutAlert, animated: true, completion: nil)
            
            
        }else {
             self.dismiss(animated: true, completion: nil)
        }
       
    }
    //handel Keyboard 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameTextField:
            emailTextField.becomeFirstResponder()
        case self.emailTextField:
            passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            confirmTextField.becomeFirstResponder()
            
        default:
            confirmTextField.resignFirstResponder()
            SignUpClicked(self)        }
        return true
    }
}
