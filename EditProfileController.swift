//
//  EditProfileController.swift
//  vKclub
//
//  Created by Machintos-HD on 7/8/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController {
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var currentpass: UITextField!
    @IBOutlet weak var UpdateBtn: UIButton!
    let User = UserProfile(context: manageObjectContext)
    
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
            
        }else{
           let currentuser = Auth.auth().currentUser
           let changeRequest = currentuser?.createProfileChangeRequest()
            print(currentuser?.displayName,"==")
            print(currentuser?.createProfileChangeRequest())
            
           changeRequest?.displayName = Username.text
            
           
            changeRequest?.commitChanges { (error) in
                print(error)
                
            }
          
            
           let credential = EmailAuthProvider.credential(withEmail:(currentuser?.email)!, password: currentpass.text!)
           currentuser?.reauthenticate(with: credential, completion: { (error) in
            if error == nil {
                
                currentuser?.updateEmail(to: self.Email.text! , completion: { (error) in
                    if error == nil{
                        self.UpdateUsernameandemail(username: (changeRequest?.displayName)!, email:self.Email.text!)
                        print("Done", "==")
                    }else{
                        print(error)
                    }
                })
            
                
                
            }else{
                print(error)
            }
           })
            
            
         self.reNew()
            
         
            
            
        }
        
        
    }
    
    func UpdateUsernameandemail(username:String, email:String){
        var people : [UserProfile] = [User]
        let firstPerson =  personService.getById(id: (people[0].objectID))!
        if firstPerson.isInserted {
            
            firstPerson.username  = username
            firstPerson.email     = email
            personService.update(updatedPerson: firstPerson)
            
            print("odme")
            
        }else{
            
        }
    }
    
    func reNew(){
       
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "MainDashboard")
    }
   
    

   

}
