//
//  LoginViewController.swift
//  vKclub
//
//  Created by Pisal on 7/31/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import ProgressHUD
import SVProgressHUD
import FirebaseAuth
import PopupDialog
import FirebaseFirestore
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate , UINavigationControllerDelegate{
//    let personService = UserProfileCoreData()
    let profileVariables = ProfileOverlayNavigationBar()
    let detailProfileVariables = DetailProfileVariables()
    let cardViewInstance = ExploreCategoryComponents()
    let loginRegisterComponent = EditProfileVariables()
    var emailUserInput: String!
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        setupViewAppear()
    
//        if AccountCreated {
//            self.PresentDialogOneActionController(title: "Successfully", message: "You have successfully registered with our server. Now you can login.", actionTitle: "Okay")
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        hideKeyboardWhenTappedAround()
        setupViews()
        loginRegisterComponent.emailTextField.delegate = self
        loginRegisterComponent.currentPassword.delegate = self
      
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        AccountCreated = false
    }
    
}

//App Cycle


// Setup all views
extension LoginViewController {
    
    func setupViews() {
        view.addSubview(profileVariables.profileView)
        view.addSubview(detailProfileVariables.detailProfileView)
        view.addSubview(loginRegisterComponent.createAccButton)
        
        self.constraintProfileView()
        self.constraintViewBelowProfileView()
        
        self.profileViewSubview()
        self.constraintImageCoverView()
        
        self.setupLoginMainView ()
        
        self.constraintCreateAcc ()
        self.setupForgotPasswordButton ()
        self.setupButtonAction ()
    }
    
}

// Handle Keyboard
extension LoginViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case self.loginRegisterComponent.emailTextField:
            loginRegisterComponent.currentPassword.becomeFirstResponder()
            
        case self.loginRegisterComponent.currentPassword:
            
            loginTouchUpInside()
            self.view.endEditing(true)
        default:
            loginTouchUpInside()
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.loginRegisterComponent.currentPassword:
            loginRegisterComponent.currentPassword.returnKeyType = UIReturnKeyType.go
        default:
            print("=====")
        }
        
    }
    
}

// Handle Buttons Action
extension LoginViewController {
    

    @objc
    func createAccTouchUpInside () {
        
        print("Moving to next view")
        
        let createAccController = CreateAccountController()
       
        if (loginRegisterComponent.currentPassword.text?.isEmpty == false) ||  (loginRegisterComponent.emailTextField.text?.isEmpty == false) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.PresentDialogForLeavingView(title: "Warning", message: "Are you sure want to leave? This will not save your information", nextViewController: createAccController, leaveToSipController: false)
            
        } else {
            //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navigationController?.pushViewController(createAccController, animated: true)
        }
        
        
        
    }
    
    @objc
    func loginTouchUpInside () {
        
        
        ProgressHUD.show("Loading...", interaction: false)
        InternetConnection.second = 0
        InternetConnection.countTimer.invalidate()
        if loginRegisterComponent.emailTextField.text == "" && loginRegisterComponent.currentPassword.text == "" {
            
            ProgressHUD.showError("Please enter your email.")
            return
            
        }
        if ( loginRegisterComponent.emailTextField.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your email.")
            return
        }
        if (loginRegisterComponent.currentPassword.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your password.")
            return
        } else {
            //handle firebase sign in
            //InternetConnection.CountTimer()
            Auth.auth().signIn(withEmail: loginRegisterComponent.emailTextField.text!, password: loginRegisterComponent.currentPassword.text!, completion: { (user, error) in
//                if InternetConnection.second == 15 {
//                    InternetConnection.countTimer.invalidate()
//                    InternetConnection.second = 0
//                    UIComponentHelper.ProgressDismiss()
//                    return
//                }
                
                if error == nil {
//                    InternetConnection.countTimer.invalidate()
//                    InternetConnection.second = 0
                 
                    
                    
                    if (user?.isEmailVerified)! {
                        if(user?.photoURL == nil){
                            let img = UIImage(named: "detailprofile-icon")
                            let newImage = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 400, height: 400))
                            let imageProfiles = UIImagePNGRepresentation(newImage)

                            //self.create(username: (user?.displayName)!,email : (user?.email)!, imagData: imageProfiles! as NSData  )


                        } else {
                            self.getDataFromUrl(url: (user?.photoURL!)!){
                                (data, response, error)  in
                                guard let data = data, error == nil
                                    else {
                                        return
                                }
                                let image = data as NSData?
                                //self.create(username: (user?.displayName)!,email : (user?.email)!, imagData: image!  as NSData )
                            }

                        }
                        
//                        logouts = false
                        

                        self.validation(uid: (Auth.auth().currentUser?.uid)!)
                        print("Email is verified")
                        
                    }
                    else {
                        ProgressHUD.dismiss()
                        //View.activityIndicatorMode(view: self.view, display: false, inDetailProfileView: true)
                        self.PresentDialogOneActionController(title: "Confirmation", message: "Please verify your email address with a link that we have already sent you to proceed login in", actionTitle: "Okay")
                    }
                
                    
                }else {
                    ProgressHUD.dismiss()
                    //View.activityIndicatorMode(view: self.view, display: false, inDetailProfileView: true)
                    let check: String = (error?.localizedDescription)!
                    print(check,"||")
                    switch check {
                    case "There is no user record corresponding to this identifier. The user may have been deleted.":
                        self.PresentDialogOneActionController(title: "Error", message: "The username and password you entered did not match our records. Please double-check and try again.", actionTitle: "Okay")
                        break
                    case "The password is invalid or the user does not have a password.":
                        Auth.auth().fetchProviders(forEmail: self.loginRegisterComponent.emailTextField.text!, completion: { (accData, error) in
                            if error == nil{
                                if accData == nil {
                                    self.PresentDialogOneActionController(title: "Something went wrong", message: "The email you entered did not match our records. Please double-check and try again.", actionTitle: "Got it")
                                    return
                                }else {
                                    self.PresentDialogOneActionController(title: "Error", message: "The password is invalid or the user does not have a password.", actionTitle: "Okay")
                                }
                                
                            } else {
                                self.PresentDialogOneActionController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                return
                                
                            }
                        })
                        
                        break
                    default:
                        self.PresentDialogOneActionController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        break
                        
                        
                    }
                    
                }
            })
            
            
        }
        
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask (with: url) { (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    func validation(uid: String){

        
        
        let currentUser = Auth.auth().currentUser
        
        
        let jsonUser = UserModel(extension: uid, password: loginRegisterComponent.currentPassword.text!, username: (currentUser?.displayName!)!, email: (loginRegisterComponent.emailTextField.text?.capitalizingFirstLetter())!)
        
        FIRFireStoreService.shared.loginUserFirestore(for: jsonUser, in: .users, returning: UserModel.self) { (done) in
            if done {
                print("done")
//                self.finishedLoggedIn()
            } else {
                print("Cannot register")
                ProgressHUD.dismiss()
                self.PresentDialogOneActionController(title: "Error", message: "Cannot login right now.", actionTitle: "Okay")
            }
            
        }
        
        
    
    }
//    func finishedLoggedIn() {
//        
//        
//        FIRFireStoreService.shared.readUserProfileFirestore(for: GenerateUserInfo.getUserModel(), in: .users, returning: UserModel.self, completion: { (data, success) in
//            if success {
//                for user in data {
//                    
//                    print("User Model is ", user)
//                    
//                    guard let id = user.id else {
//                        return
//                    }
//                    
//                    print("User id ", id)
//                    UserDefaults.standard.setUserId(value: id)
//                    ProgressHUD.dismiss()
//                    UserDefaults.standard.setIsLoggedIn(value: true)
//                    self.dismiss(animated: true, completion: nil)
//                }
//                
//            } else {
//                ProgressHUD.dismiss()
//                self.PresentDialogOneActionController(title: "Error", message: "There was an error occurs. Please try to Log In again.", actionTitle: "Okay")
//            }
//        })
//        
//        
//    }
    
    @objc
    func backHome() {
        
        if (loginRegisterComponent.currentPassword.text?.isEmpty == false) ||  (loginRegisterComponent.emailTextField.text?.isEmpty == false) {
            
            self.PresentDialogForLeavingView(title: "Warning", message: "Are you sure want to leave? This will not save your information.", nextViewController: self, leaveToSipController: true)
            
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
}


// Helper function and setup btn action

extension LoginViewController {
    
    func PresentDialogForLeavingView (title: String, message: String, nextViewController: UIViewController, leaveToSipController: Bool) {
        
        CustomPopupDialogView()
        
        let Popup = PopupDialog(title: title, message: message)
        
        let okayButton = DefaultButton(title: "Okay") {
            
            if self.loginRegisterComponent.emailTextField.text != nil {
                self.loginRegisterComponent.emailTextField.text = ""
            }
            if self.loginRegisterComponent.currentPassword.text != nil {
                self.loginRegisterComponent.currentPassword.text = ""
            }
            
            if leaveToSipController {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                let viewController = nextViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            
            
        }
        let cancelButton = CancelButton(title: "Cancel") {
            
        }
        
        Popup.addButtons([okayButton , cancelButton])
        
        self.present(Popup, animated: true, completion: nil)
        
        
    }
    
    func setupNavigation() {
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel-edit")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backHome))
    }
    func setupViewAppear() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func setupButtonAction () {
        
        loginRegisterComponent.createAccButton.addTarget(self, action: #selector(createAccTouchUpInside), for: .touchUpInside)
        
        loginRegisterComponent.loginButton.addTarget(self, action: #selector(loginTouchUpInside), for: .touchUpInside)
        
       
        loginRegisterComponent.forgotPasswordButton.addTarget(self, action: #selector(forgotPassTouchUpInside), for: .touchUpInside)
    }
   
  
    @objc
    func forgotPassTouchUpInside() {
       
        let forgotPassViewController = ForgotPasswordViewController()
        self.navigationController?.pushViewController(forgotPassViewController, animated: true)
        
    }
}
