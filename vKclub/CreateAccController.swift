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
    let storageRef = Storage.storage().reference()

    override func viewDidLoad() {
        UIComponentHelper.MakeBtnWhiteBorder(button: signUpBtn, color: UIColor.white)
        UIComponentHelper.MakeBtnWhiteBorder(button: backBtn, color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: nameTextField, name: "Name", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: emailTextField, name: "Email", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: passwordTextField, name: "Password", color: UIColor.white)
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: confirmTextField, name: "Confirm Password", color: UIColor.white)
    }
    @IBAction func SignUpClicked(_ sender: Any) {
        let length_password : Int = (passwordTextField.text?.characters.count)!
        if (nameTextField.text?.isEmpty)! && (emailTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)! && (confirmTextField.text?.isEmpty)! {
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
            return
        }
        
        if (nameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmTextField.text?.isEmpty)! {
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
            return
        } else if confirmTextField.text !=  passwordTextField.text {
            PresentAlertController(title: "Something went wrong", message: "Your password doesn't match with confirm password", actionTitle: "Got it")
             return
        } else if length_password < 6 {
            PresentAlertController(title: "Something went wrong", message: "Pleaes enter your password more then 6 characters", actionTitle: "Got it")
            return
        }
        else {
            //show loading activity indicator
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                //successfully created, done loading activity indicator
                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                
                if (error == nil) {
                    let img = UIImage(named: "profile-icon")
                    let newImage = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 400, height: 400))
                    let imageProfiles = UIImagePNGRepresentation(newImage)
                    let riversRef =  self.storageRef.child("userprofile-photo").child((self.nameTextField.text)!)
                    
                    _ = riversRef.putData(imageProfiles! , metadata: nil) { (metadata, error) in
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
                    self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                }
            }
        }
    }
    @IBAction func BackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
