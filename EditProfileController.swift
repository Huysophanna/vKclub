//
//  EditProfileController.swift
//  vKclub
//
//  Created by Machintos-HD on 7/8/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class EditProfileController: UIViewController {
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var currentpass: UITextField!
    @IBOutlet weak var UpdateBtn: UIButton!
    let User = UserProfile(context:  context)
    let personService = PersonService()
    var menuControllerInstance: MenuController = MenuController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIComponentHelper.MakeWhitePlaceholderTextField(textfield: Username, name: "Name")
        UIComponentHelper.MakeWhitePlaceholderTextField(textfield: Email, name: "Email")
        UIComponentHelper.MakeWhitePlaceholderTextField(textfield: currentpass, name: "Current Password")
        UIComponentHelper.MakeBtnWhiteBorder(button: UpdateBtn )
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UpdateBtn(_ sender: Any) {
        if (Username.text?.isEmpty)! && (Email.text?.isEmpty)! && (currentpass.text?.isEmpty)!{
            self.PresentAlertController(title: "Something Wrong", message: "Please properly insert your data", actionTitle: "Ok")
            
        }else{
            let currentuser = Auth.auth().currentUser
            var current_email    = currentuser?.email
            print (current_email)
            let changeRequest = currentuser?.createProfileChangeRequest()
            
            
            let credential = EmailAuthProvider.credential(withEmail:(currentuser?.email)!, password: currentpass.text!)
            currentuser?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    
                    currentuser?.updateEmail(to: self.Email.text! , completion: { (error) in
                        if error == nil{
                            changeRequest?.displayName = self.Username.text
                            changeRequest?.commitChanges { (error) in
                                
                            }
                            self.UpdateUsernameandemail(username: (changeRequest?.displayName)!, email:self.Email.text!)
                            print(current_email)
                            print(self.Email.text)
                            let current_email_string : String = String(describing: current_email)
                            let input_email  :String  = String(describing: self.Email.text)
                         
                            // check if user change the email
                            if(current_email_string == input_email){
                                
                                self.PresentAlertController(title: "Done", message: "Your Profile had updated", actionTitle: "Ok")
                                
                                self.reNew()
                                // if chage the email need to verified new email
                                
                            }else{
                                currentuser?.sendEmailVerification(completion: { (error) in
                                    
                                })
                                self.PresentAlertController(title: "Something went wrong", message: "your Email need to verified", actionTitle: "Okay")
                                UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
                            }
                          
                        }else{
                           self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                            
                        }
                    })
                    
                }else{
                    self.PresentAlertController(title: "Something Wrong", message: "your password was wrong ", actionTitle: "Ok")
                }
            })
        }
        
        
    }
    
    func UpdateUsernameandemail(username:String, email:String){
        
        let emailProvider = NSPredicate(format: "facebookProvider = 0")
        let email_lgoin = personService.get(withPredicate: emailProvider)
        for i in email_lgoin {
            i.email = email
            i.username = username
            personService.updateUserProfile(_updatedPerson: i)
            
        }
    }
    
    func reNew(){
        
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "MainDashboard")
    }
}
