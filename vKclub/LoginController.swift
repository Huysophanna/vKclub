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
    let personService = UserProfileCoreData()
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInFBBtn: UIButton!
    let User = UserProfile(context: manageObjectContext)
    override func viewDidLoad() {
        super.viewDidLoad()
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        MakeLeftViewIconToTextField(textField: emailTextField, icon: "user_left_icon")
        MakeLeftViewIconToTextField(textField: pwTextField, icon: "pw_icon")
        UIComponentHelper.MakeBtnWhiteBorder(button: signInBtn, color: UIColor.white)
        MakeFBBorderBtn(button: signInFBBtn)
        //Btn Call Function FBSignIn
        signInFBBtn.addTarget(self, action: #selector(FBSignIn), for: .touchUpInside)
    }
    func FBSignIn(){
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("eroor", error!)
            } else if (result?.isCancelled)! {
                UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                print("Facebook Cancelled")
            } else {
                guard let accessToken = FBSDKAccessToken.current() else {
                    UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                    print("Failed to get access token")
                    return
                }
               
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if error == nil {
                        if let currentUser = Auth.auth().currentUser {
                            var getFBimageUrl  : URL = currentUser.photoURL!
                            print (getFBimageUrl,"befor++")
                            let str = currentUser.photoURL?.absoluteString
                            let index = str?.index((str?.startIndex)!, offsetBy: 30)
                            let url : String = (str?.substring(to: index!))!
                            print(url)
                            if url == "https://scontent.xx.fbcdn.net/" {
                                let FBImageUrl : String = "https://graph.facebook.com/"+FBSDKAccessToken.current().userID+"/picture?width=320&height=320"
                                getFBimageUrl = URL(string:FBImageUrl)!
                            }
                            let chageProfileuser = currentUser.createProfileChangeRequest()
                            print(getFBimageUrl,"after++")
                            chageProfileuser.photoURL = getFBimageUrl
                            chageProfileuser.commitChanges { (error) in
                                
                            }
                            self.getDataFromUrl(url: getFBimageUrl){
                            (data, response, error)  in
                                guard let data = data, error == nil
                                    else {
                                        return
                                }
                                let image = data as NSData?
                                let imageFB = UIImage(data: image! as Data)
                                let newimag = UIComponentHelper.resizeImage(image: imageFB!, targetSize: CGSize(width: 400, height: 400))
                                let imageProfiles = UIImagePNGRepresentation(newimag)
                                if (user?.email == nil){
                                    UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                                    self.create(username: (user?.displayName)!,email: "someone@gamil.com",facebook: true, imagData: imageProfiles! as NSData)
                                } else {
                                     self.create(username: (user?.displayName)!,email: (user?.email)!,facebook: true, imagData: imageProfiles! as NSData)
                                } 
                            }
                        }

                        if (user?.email == nil && user?.displayName == nil ) {
                            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                            self.PresentAlertController(title: "Error", message: "Try again, because your internet conntion was too slow", actionTitle: "Okay")
                        } else {
                            UserDefaults.standard.set(true, forKey: "loginBefore")
                            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainDashboard") as! SWRevealViewController
                            self.present(newViewController, animated: true, completion: nil)     
                        }   
                    } else {
                        UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
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
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        
        if emailTextField.text == "" || pwTextField.text == "" {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            
            PresentAlertController(title: "Something went wrong", message: "Please properly insert your data", actionTitle: "Got it")
            
        } else {
            //handle firebase sign in
            
            //UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
                if error == nil {
                    if (user?.isEmailVerified)!{
                        // if user don't name and imageprofile
                     
                        self.getDataFromUrl(url: (user?.photoURL!)!){
                                (data, response, error)  in
                                guard let data = data, error == nil
                                    else {    
                                        return
                                }
                                let image = data as NSData?
                                self.create(username: (user?.displayName)!,email : (user?.email)!,facebook: false, imagData: image!  )
                                }
                        UserDefaults.standard.set(true, forKey: "loginBefore")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainDashboard") as! SWRevealViewController
                        self.present(newViewController, animated: true, completion: nil)
                            
                    
                        
                    } else {
                        UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                        self.PresentAlertController(title: "Comfirmation", message: "Please verify your email address with a link that we have already sent you to proceed login in", actionTitle: "Okay")
                    }
                } else {
                    UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
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
        imageView.frame = CGRect(x: Int(textField.frame.height / 3), y: Int(textField.frame.height / 3), width: Int(textField.frame.height / 2.5), height: Int(textField.frame.height / 2.5))
        textField.addSubview(imageView)
        
        let leftView = UIView.init(frame: CGRect(x: 10, y: 10, width: textField.frame.height, height: 25))
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewMode.always
        
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask (with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    func create(username:String, email:String, facebook: Bool, imagData: NSData){
        var people : [UserProfile] = [User]
        let firstPerson =  personService.getByIdUserProfile(_id: (people[0].objectID))!
        if firstPerson.isInserted {
            firstPerson.facebookProvider = facebook
            firstPerson.imageData = imagData
            firstPerson.username  = username
            firstPerson.email     = email
            personService.updateUserProfile(_updatedPerson: firstPerson)
        }
    }
}
