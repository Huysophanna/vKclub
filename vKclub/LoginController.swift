//
//  LoginController.swift
//  vKclub
//
//  Created by HuySophanna on 30/5/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import CoreData


class LoginController: UIViewController {
    
    let personService = PersonService()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInFBBtn: UIButton!
    let User = UserProfile(context: context)
       override func viewDidLoad() {
        
        super.viewDidLoad()
        MakeLeftViewIconToTextField(textField: emailTextField, icon: "user_left_icon.png")
        MakeLeftViewIconToTextField(textField: pwTextField, icon: "pw_icon.png")
        
        UIComponentHelper.MakeBtnWhiteBorder(button: signInBtn)
        MakeFBBorderBtn(button: signInFBBtn)
        // Btn Call Function FBSignIn
        signInFBBtn.addTarget(self, action: #selector(FBSignIn), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func FBSignIn(){
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil{
                print("eroor",error)
            }else if (result?.isCancelled)! {
                print("Facebook Cancelled")
                

            }else{
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    
                    if error == nil {
                        
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainDashboard") as! SWRevealViewController
                        self.present(newViewController, animated: true, completion: nil)
                        
                        
                        
                        if let currentUser = Auth.auth().currentUser {
                            self.getDataFromUrl(url: currentUser.photoURL!){
                                
                                (data, response, error)  in
                                guard let data = data, error == nil
                                    else {
                                        return
                                }
                                let image = data as NSData?
                                
                                self.create(username: (user?.displayName)!,email: (user?.email)!,facebook: true, imagData: image! )
                                
                            }
                            
                        }
                        
                        
                    }
                    else{
                        print("Login error: \(error?.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    
                });
            }
        }
    }
    
    
    
    @IBAction func SignInClicked(_ sender: Any) {
        if emailTextField.text == "" || pwTextField.text == "" {
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
            
        } else {
            //handle firebase sign in

//            UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in

                
                if error == nil {
                    
                    // if user don't name and imageprofile
                    if(user?.photoURL == nil ){
                        print("username",user?.displayName)
                        let img = UIImage(named: "profile-icon")
                        let data :NSData = UIImagePNGRepresentation(img!)! as NSData
                        self.create(username: (user?.displayName)!,email : (user?.email)!,facebook: false, imagData: data )
                        
                       
                       
                        
                     }else {
                        self.getDataFromUrl(url: (user?.photoURL!)!){
                            
                            (data, response, error)  in
                            guard let data = data, error == nil
                            else {
                    
                                return
                            }
                        let image = data as NSData?
                        self.create(username: (user?.displayName)!,email : (user?.email)!,facebook: false, imagData: image!  )
                            
                        }
                        
                        
                    }
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainDashboard") as! SWRevealViewController

                    self.present(newViewController, animated: true, completion: nil)
                    
                }else {

                    self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                }
                
            }
        }
    }
    
    @IBAction func CreateAccount(_ sender: Any) {
        performSegue(withIdentifier: "SegueToCreateAcc", sender: self)
    }
    
    @IBAction func ForgotPWClicked(_ sender: Any) {
        performSegue(withIdentifier: "SegueToForgotPW", sender: self)
    }
    
    
    func MakeFBBorderBtn(button: UIButton) {
        button.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0).cgColor
        button.layer.cornerRadius = 5
    }
    
    func MakeLeftViewIconToTextField(textField: UITextField, icon: String) {
        let imageView = UIImageView();
        let image = UIImage(named: icon);
        imageView.image = image;
        imageView.frame = CGRect(x: 18, y: 15, width: 20, height: 20)
        textField.addSubview(imageView)
        let leftView = UIView.init(frame: CGRect(x: 10, y: 10, width: 45, height: 25))
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewMode.always
        
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func create(username:String,email:String,facebook: Bool, imagData: NSData){
        
        var people : [UserProfile] = [User]
        let firstPerson =  personService.getById(id: (people[0].objectID))!
        print(firstPerson.objectID)
        print ("detet",firstPerson.isDeleted)
        print ("instentd",firstPerson.isInserted)
        if firstPerson.isInserted {
            firstPerson.facebookProvider = facebook
            firstPerson.imageData = imagData
            firstPerson.username  = username
            firstPerson.email     = email
            personService.update(updatedPerson: firstPerson)
            print(firstPerson)
            print(firstPerson.facebookProvider)
            print(firstPerson.imageData)
            firstPerson.accessibilityDecrement()
            print("odme")
            
        }else{
            
        }
        
        
        
    }
    
    
}
