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
        
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Username, name: (currentuser?.displayName)!, color: UIColor(hexString: "#008040", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: Email, name: (currentuser?.email)!, color: UIColor(hexString: "#008040", alpha: 1))
        UIComponentHelper.MakeCustomPlaceholderTextField(textfield: currentpass, name: "Current Password", color: UIColor(hexString: "#008040", alpha: 1))
        
        UIComponentHelper.MakeBtnWhiteBorder(button: UpdateBtn, color: UIColor(hexString: "#008040", alpha: 1))
        Username.text = currentuser?.displayName
        Email.text    = currentuser?.email
        
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
        let changeRequest = currentuser?.createProfileChangeRequest()
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        if InternetConnection.isConnectedToNetwork() {
            print("have internet")
        } else{
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            self.PresentAlertController(title: "Something went wrong", message: "Can not update your Profile right now. Please Check you internet connection ", actionTitle: "Got it")
            return
        }
       
        
        if Username.text! == currentuser?.displayName && Email.text == currentuser?.email{
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            self.PresentAlertController(title: "Something Wrong", message: "Please properly insert your data", actionTitle: "Ok")
            return
        }
       
        if (currentpass.text?.isEmpty)!{
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            self.PresentAlertController(title: "Something Wrong", message: "Please properly insert your data", actionTitle: "Ok")
            
        } else {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            if Email.text == currentuser?.email{
               
                changeRequest?.displayName = self.Username.text
                changeRequest?.commitChanges { (error) in
                }
                self.UpdateUsernameandemail(username: (changeRequest?.displayName)!, email: (self.currentuser?.email)!)
                self.PresentAlertController(title: "Done", message: "Your Profile had updated", actionTitle: "Ok")
                self.reNew()
            }else{
                let notificationPermissionAlert = UIAlertController(title: "Warning", message: "After you change your email. You need to verified", preferredStyle: UIAlertControllerStyle.alert)
                
                notificationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                    let credential = EmailAuthProvider.credential(withEmail:(self.currentuser?.email)!, password: self.currentpass.text!)
                    self.currentuser?.reauthenticate(with: credential, completion: { (error) in
                        if error == nil{
                            
                            self.currentuser?.updateEmail(to: self.Email.text!, completion: { (error) in
                                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                                if error == nil{
                                    changeRequest?.displayName = self.Username.text
                                    changeRequest?.commitChanges { (error) in
                                    }
                                    self.UpdateUsernameandemail(username: (changeRequest?.displayName)!, email: (self.currentuser?.email)!)
                                    self.currentuser?.sendEmailVerification(completion: { (error) in
                                        
                                    })
                                    self.PresentAlertController(title: "Something went wrong", message: "your new Email  "+(self.currentuser?.email)!+"   need to verified", actionTitle: "Okay")
                                    UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
                                    
                                } else{
                                    
                                    UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                                    self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                    return
                                }
                            })
                            
                        } else {
                            
                            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
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

