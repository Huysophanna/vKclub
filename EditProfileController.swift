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
    let currentuser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Username, name: (currentuser?.displayName)!, color: UIColor(hexString: "#736F6E", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Email, name: (currentuser?.email)!, color: UIColor(hexString: "#736F6E", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: currentpass, name: "Current Password", color: UIColor(hexString: "#736F6E", alpha: 1))
        
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
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: true)
        if InternetConnection.isConnectedToNetwork() {
            print("have internet")
        } else{
            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
            self.PresentAlertController(title: "Something went wrong", message: "Can not update your Profile right now. Please Check you internet connection ", actionTitle: "Got it")
            return
        }
        if ((Username.text?.isEmpty)! && (Email.text?.isEmpty)!){
            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
            self.PresentAlertController(title: "Something Wrong", message: "Please properly insert your data", actionTitle: "Ok")
            return
        }
        
        if (currentpass.text?.isEmpty)!{
            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
            self.PresentAlertController(title: "Something Wrong", message: "Please properly insert your data", actionTitle: "Ok")
            
        } else {
            let credential = EmailAuthProvider.credential(withEmail:(currentuser?.email)!, password: currentpass.text!)
            let changeRequest = currentuser?.createProfileChangeRequest()
            if (Email.text?.isEmpty)!{
                if( self.Username.text == currentuser?.displayName){
                    self.PresentAlertController(title: "Waring", message: "If you wish to update your profile please don't input the same data", actionTitle: "Ok")
                    return
                }
                UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                changeRequest?.displayName = Username.text
                changeRequest?.commitChanges(completion: { (error) in
                })
                UpdateUsernameandemail(username:Username.text!, email:(currentuser?.email)!)
                self.PresentAlertController(title: "Done", message: "Your profile had been updated", actionTitle: "Ok")
                self.reNew()
                
            }else{
                let validateEmails = UIComponentHelper.validateEmail(enteredEmail: Email.text!)
                if validateEmails{
                    
                }else{
                    UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                    self.PresentAlertController(title: "Waring", message: "Your Email in bad format", actionTitle: "Ok")
                    return
                }
                
                if Email.text == currentuser?.email {
                    UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                    if (self.Username.text?.isEmpty)!{
                        self.PresentAlertController(title: "Waring", message: "If you wish to update your profile please don't input the same data", actionTitle: "Ok")
                        return
                    } else {
                        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                        if(self.Username.text == currentuser?.displayName){
                            self.PresentAlertController(title: "Waring", message: "If you wish to update your profile please don't input the same data", actionTitle: "Ok")
                            return
                        }
                        
                    }
                    
                    changeRequest?.displayName = self.Username.text
                    changeRequest?.commitChanges(completion: { (error) in
                    })
                    UpdateUsernameandemail(username:Username.text!, email:(currentuser?.email)!)
                    self.PresentAlertController(title: "Done", message: "Your profile had been updated", actionTitle: "Ok")
                    
                    self.reNew()
                } else {
                    UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                    let notificationPermissionAlert = UIAlertController(title: "Warning", message: "After you change your email. You need to verified", preferredStyle: UIAlertControllerStyle.alert)
                    
                    notificationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: true)
                        self.currentuser?.reauthenticate(with: credential, completion: { (error) in
                            if error == nil {
                                UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                                self.currentuser?.updateEmail(to: self.Email.text!, completion: { (error) in
                                    if error == nil {
                                        if (self.Username.text?.isEmpty)!{
                                            changeRequest?.displayName = self.currentuser?.displayName
                                            changeRequest?.commitChanges(completion: { (error) in
                                            })
                                        } else {
                                            changeRequest?.displayName = self.Username.text
                                            changeRequest?.commitChanges(completion: { (error) in
                                            })
                                        }
                                    } else {
                                        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                        return
                                    }
                                    
                                    UserDefaults.standard.set(false, forKey: "loginBefore")
                                    self.currentuser?.sendEmailVerification(completion: { (error) in
                                        
                                    })
                                    self.PresentAlertController(title: "Something went wrong", message: "your new Email  "+(self.currentuser?.email)!+"   need to verified", actionTitle: "Okay")
                                    UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
                                })
                                
                                
                                
                            } else {
                                
                                UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                                self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                return
                            }
                            
                            
                        })
                        
                    }))
                    notificationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
                    self.present(notificationPermissionAlert, animated: true, completion: nil)
                    
                }
                
                
            }
            
            
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

