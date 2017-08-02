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
    let User = UserProfile(context: manageObjectContext)
    let internetConnection = InternetConnection()
    
    let personService = UserProfileCoreData()
    
    var menuControllerInstance: MenuController = MenuController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Username, name: "Name (Optional)", color: UIColor(hexString: "#008040", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Email, name: "Email (Optional)†", color: UIColor(hexString: "#008040", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: currentpass, name: "Current Password", color: UIColor(hexString: "#008040", alpha: 1))
        
        UIComponentHelper.MakeBtnWhiteBorder(button: UpdateBtn, color: UIColor(hexString: "#008040", alpha: 1))
        
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
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        if InternetConnection.isConnectedToNetwork() {
            print("have internet")
        } else{
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            self.PresentAlertController(title: "Something went wrong", message: "Can not update your Profile right now. Please Check you internet connection ", actionTitle: "Got it")
            return
        }
        if ((Username.text?.isEmpty)! && (Email.text?.isEmpty)!){
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            self.PresentAlertController(title: "Something Wrong", message: "Please properly insert your data", actionTitle: "Ok")
            return
        }
       
        if (currentpass.text?.isEmpty)!{
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            self.PresentAlertController(title: "Something Wrong", message: "Please properly insert your data", actionTitle: "Ok")
            
        } else {
            let currentuser = Auth.auth().currentUser
            let current_email = String(describing: currentuser?.email)
            let changeRequest = currentuser?.createProfileChangeRequest()
            
            let credential = EmailAuthProvider.credential(withEmail:(currentuser?.email)!, password: currentpass.text!)
            currentuser?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    if (self.Email.text?.isEmpty)! {
                        currentuser?.updateEmail(to: (currentuser?.email)! , completion: { (error) in
                            if error == nil{
                                
                                changeRequest?.displayName = self.Username.text
                                
                                changeRequest?.commitChanges { (error) in
                                    
                                }
                                self.UpdateUsernameandemail(username: (changeRequest?.displayName)!, email: (currentuser?.email)!)
                                self.PresentAlertController(title: "Done", message: "Your Profile had updated", actionTitle: "Ok")
                                self.reNew()
                               
                                
                            } else{
                               
                                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                                self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                            }
                        })
                        
                    } else {
                        currentuser?.updateEmail(to: self.Email.text! , completion: { (error) in
                            if error == nil{
                                if (self.Username.text?.isEmpty)!{
                                     changeRequest?.displayName = currentuser?.displayName
                                    
                                } else {
                                     changeRequest?.displayName = self.Username.text
                                }
                                changeRequest?.commitChanges { (error) in
                                }
                                self.UpdateUsernameandemail(username: (changeRequest?.displayName)!, email:self.Email.text!)
                                let current_email_string : String = String(describing: current_email)
                                let input_email  :String  = String(describing: self.Email.text)
                                // check if user change the email
                                if(current_email_string == input_email){
                                   self.PresentAlertController(title: "Done", message: "Your Profile had updated", actionTitle: "Ok")
                                    self.reNew()
                                    // if chage the email need to verified new email
                                    
                                }else{
                                    UserDefaults.standard.set(false, forKey: "loginBefore")
                                    currentuser?.sendEmailVerification(completion: { (error) in
                                        
                                    })
                                    self.PresentAlertController(title: "Something went wrong", message: "Your Email need to verified", actionTitle: "Okay")
                                    UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
                                }
                                
                            } else {
                                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                                self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                
                            }
                        })
                    }
                    
                } else {
                    UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                    self.PresentAlertController(title: "Something Wrong", message: (error?.localizedDescription)!, actionTitle: "Ok")
                }
            })
        }
        
        
    }
    
    func UpdateUsernameandemail(username:String, email:String){
        
        let emailProvider = NSPredicate(format: "facebookProvider = 0")
        let email_lgoin = personService.getUserProfile(withPredicate: emailProvider)
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
