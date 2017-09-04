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

class EditProfileController: UIViewController,UITextFieldDelegate {
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
        hideKeyboardWhenTappedAround()
        
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Username, name: (currentuser?.displayName)!, color: UIColor(hexString: "#736F6E", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Email, name: (currentuser?.email)!, color: UIColor(hexString: "#736F6E", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: currentpass, name: "Current Password", color: UIColor(hexString: "#736F6E", alpha: 1))
        Username.delegate = self
        Email.delegate = self
        currentpass.delegate = self
        UIComponentHelper.MakeBtnWhiteBorder(button: UpdateBtn, color: UIColor(hexString: "#008040", alpha: 1))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        CheckBeforeLeave()
    }
    
    @IBAction func UpdateBtn(_ sender: Any) {
        let length_password : Int = (currentpass.text!.characters.count)
        var lenth_username : Int = (Username.text?.characters.count)!
        let specialcharaters = UIComponentHelper.AvoidSpecialCharaters(specialcharaters: Username.text!)
        let conutwhitespece : Int = UIComponentHelper.Countwhitespece(_whitespece:Username.text!)
        if (Username.text?.isEmpty)!{
            lenth_username  = (currentuser!.displayName!.characters.count)
            
        }

        if InternetConnection.isConnectedToNetwork() {
            print("have internet")
        } else{
            self.PresentAlertController(title: "Warning", message: "Cannot update your Profile right now. Please Check you internet connection ", actionTitle: "Got it")
            return
        }
        if ((Username.text?.isEmpty)! && (Email.text?.isEmpty)!){
            self.PresentAlertController(title: "Warning", message: "Please properly insert your data", actionTitle: "Ok")
            return
        }
        
        if length_password < 6 {
            PresentAlertController(title: "Warning", message: "Pleaes enter your password more then 6 characters", actionTitle: "Got it")
            
            return
        } else if length_password > 20 {
            PresentAlertController(title: "Warning", message: "Pleaes enter your password less then 20 characters", actionTitle: "Got it")
            return
        } else if lenth_username < 5 {
            PresentAlertController(title: "Warning", message: "Pleaes enter your name more then 5 characters", actionTitle: "Got it")
            return
            
        } else if lenth_username > 20 {
            PresentAlertController(title: "Warning", message: "Pleaes enter your name less then 20 characters", actionTitle: "Got it")
            return
            
        } else if specialcharaters == false {
            PresentAlertController(title: "Warning", message: "Your username should not contant with special charaters or number", actionTitle: "Got it")
            return
        } else if conutwhitespece >= 3 {
            
            PresentAlertController(title: "Warning", message: "Your username should not contant more then 3 white spece", actionTitle: "Got it")
            return
        } else {
            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: true)

            if (currentpass.text?.isEmpty)!{
                UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                self.PresentAlertController(title: "Warning", message: "Please properly insert your data", actionTitle: "Ok")
                return
            } else {
                let credential = EmailAuthProvider.credential(withEmail:(currentuser?.email)!, password: currentpass.text!)
                self.currentuser?.reauthenticate(with: credential, completion: { (error) in
                    if error != nil{
                        let check : String = (error?.localizedDescription)!
                        switch check{
                            case "The password is invalid or the user does not have a password.":
                                self.PresentAlertController(title: "Error", message: "Please provide a valid password.", actionTitle: "Okay")
                                break
                        default:
                            self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                            
                            break
                        }
                        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        return
                    }else{
                        
                        let changeRequest = self.currentuser?.createProfileChangeRequest()
                        if (self.Email.text?.isEmpty)!{
                            if( self.Username.text == self.currentuser?.displayName){
                                self.PresentAlertController(title: "Waring", message: "If you wish to update your profile please don't input the same data", actionTitle: "Ok")
                                return
                            }
                            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                            changeRequest?.displayName = self.Username.text
                            changeRequest?.commitChanges(completion: { (error) in
                                if error != nil {
                                    self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                }

                            })
                            self.UpdateUsernameandemail(username:self.Username.text!, email:(self.currentuser?.email)!)
                            self.PresentAlertController(title: "Done", message: "Your profile had been updated", actionTitle: "Okay")
                            self.reNew()
                            
                        }else{
                            if self.Email.text == self.currentuser?.email {
                                UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                                if (self.Username.text?.isEmpty)!{
                                    self.PresentAlertController(title: "Waring", message: "If you wish to update your profile please don't input the same data", actionTitle: "Okay")
                                    return
                                } else {
                                    UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                                    if(self.Username.text == self.currentuser?.displayName){
                                        self.PresentAlertController(title: "Waring", message: "If you wish to update your profile please don't input the same data", actionTitle: "Okay")
                                        return
                                    }
                                    
                                }
                                
                                changeRequest?.displayName = self.Username.text
                                changeRequest?.commitChanges(completion: { (error) in
                                    if error != nil {
                                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                    }

                                })
                                self.UpdateUsernameandemail(username:self.Username.text!, email:(self.currentuser?.email)!)
                                self.PresentAlertController(title: "Done", message: "Your profile had been updated", actionTitle: "Okay")
                                
                                self.reNew()
                            } else {
                                UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                                let notificationPermissionAlert = UIAlertController(title: "Warning", message: "After you change your email. You need to verified", preferredStyle: UIAlertControllerStyle.alert)
                                
                                notificationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                                    UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: true)
                                    self.currentuser?.updateEmail(to: self.Email.text!, completion: { (error) in
                                        if error == nil {
                                            if (self.Username.text?.isEmpty)!{
                                                changeRequest?.displayName = self.currentuser?.displayName
                                                changeRequest?.commitChanges(completion: { (error) in
                                                    if error != nil {
                                                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                                    }

                                                })
                                            } else {
                                                changeRequest?.displayName = self.Username.text
                                                changeRequest?.commitChanges(completion: { (error) in
                                                    if error != nil {
                                                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                                    }
                                                })
                                            }
                                        } else {
                                            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                                            self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                            return
                                        }
                                        
                                        UserDefaults.standard.set(false, forKey: "loginBefore")
                                        self.currentuser?.sendEmailVerification(completion: { (error) in
                                            
                                            if error != nil{
                                                self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")}
                                            
                                        })
                                        self.PresentAlertController(title: "Warning", message: "Your new Email  \n"+(self.currentuser?.email)!+"  need to verified.\n Please verify your email address with a link that we have already sent you to proceed login in", actionTitle: "Okay")
                                        UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
                                    })
                                }))
                                notificationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
                                self.present(notificationPermissionAlert, animated: true, completion: nil)
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                })
                
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.Username:
            Email.becomeFirstResponder()
        case self.Email:
            currentpass.becomeFirstResponder()
            
        default:
            currentpass.resignFirstResponder()
            UpdateBtn(self)
        }
        return true
    }
    func CheckBeforeLeave(){
        if (Username.text?.isEmpty == false) || (Email.text?.isEmpty == false) || (currentpass.text?.isEmpty == false) {
            let logoutAlert = UIAlertController(title: "Go back", message: "Are you sure to go back?", preferredStyle: UIAlertControllerStyle.alert)
            
            logoutAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            }))
            logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present( logoutAlert, animated: true, completion: nil)
            
            
        } else{
             self.dismiss(animated: true, completion: nil)
        }
    }
    
}
class ChangePasswordController :UIViewController,UITextFieldDelegate {
    @IBOutlet weak var current_password: UITextField!
    
    @IBOutlet weak var new_password: UITextField!
    
    @IBOutlet weak var comfire_password: UITextField!
    
    @IBOutlet weak var change_password: UIButton!
    let currentuser = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: current_password, name: "Current Password", color: UIColor(hexString: "#736F6E", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: new_password, name: "New Password", color: UIColor(hexString: "#736F6E", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: comfire_password, name: "Confirm Password", color: UIColor(hexString: "#736F6E", alpha: 1))
        current_password.delegate = self
        new_password.delegate = self
        comfire_password.delegate = self
        
        UIComponentHelper.MakeBtnWhiteBorder(button: change_password, color: UIColor(hexString: "#008040", alpha: 1))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ChangePasswordBtn(_ sender: Any) {
        
        if (current_password.text?.isEmpty)! || (new_password.text?.isEmpty)! || (comfire_password.text?.isEmpty)!{
            self.PresentAlertController(title: "Warning", message: "Please properly insert your data", actionTitle: "Ok")
            return
            
        } else if new_password.text != comfire_password.text {
            PresentAlertController(title: "Warning", message: "Your password doesn't match with confirm password", actionTitle: "Okay")
            return
        } else {
            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: true)
            let length_password : Int = (new_password.text!.characters.count)
            let length_current : Int = (current_password.text!.characters.count)
            if length_password < 6 || length_current < 6 {
                 UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                PresentAlertController(title: "Warning", message: "Pleaes enter your password more then 6 characters", actionTitle: "Got it")
                return
  
            }
            let credential = EmailAuthProvider.credential(withEmail:(currentuser?.email)!, password:self.current_password.text!)
            currentuser?.reauthenticate(with: credential, completion: { (error) in
                UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
                if error == nil {
                    self.currentuser?.updatePassword(to: self.new_password.text!, completion: { (error) in
                        if error == nil{
                            self.current_password.text = ""
                            self.new_password.text = ""
                            self.comfire_password.text = ""
                            let Alert = UIAlertController(title: "Done", message: "Your password success updated", preferredStyle: UIAlertControllerStyle.alert)
                            
                            Alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.dismiss(animated: true, completion: nil)
                                                            
                            }))
                            self.present(Alert, animated: true, completion: nil)
                            
                        } else {
                            self.PresentAlertController(title: "Warning", message:(error?.localizedDescription)! , actionTitle: "Okay")
                            return
                        }
                    })

                    
                } else {
                    let check : String = (error?.localizedDescription)!
                    switch check{
                    case "The password is invalid or the user does not have a password.":
                        self.PresentAlertController(title: "Error", message: "Please provide a valid password.", actionTitle: "Okay")
                        break
                    default:
                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        
                        break
                    }
                    return

                    
                }
            })
        }
        
        
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        CheckBeforeLeave()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.current_password:
            new_password.becomeFirstResponder()
        case self.new_password:
            comfire_password.becomeFirstResponder()
            
        default:
            comfire_password.resignFirstResponder()
            ChangePasswordBtn(self)
        }
        return true
    }

    
    func CheckBeforeLeave(){
        if (current_password.text?.isEmpty == false) || (new_password.text?.isEmpty == false) || (comfire_password.text?.isEmpty == false) {
            let logoutAlert = UIAlertController(title: "Go back", message: "Are you sure to go back?", preferredStyle: UIAlertControllerStyle.alert)
            
            logoutAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            }))
            logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present( logoutAlert, animated: true, completion: nil)
            
            
        } else{
             self.dismiss(animated: true, completion: nil)
        }
    }
}

