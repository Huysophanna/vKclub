//
//  CreateAccountViewController.swift
//  vKclub
//
//  Created by Pisal on 7/31/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import ProgressHUD
import SVProgressHUD
import PopupDialog
import Firebase
import FirebaseAuth



class CreateAccountController: UIViewController, UITextFieldDelegate , UIGestureRecognizerDelegate , UINavigationControllerDelegate{
    
    private let profileVariables = ProfileOverlayNavigationBar()
    private let detailProfileVariables = DetailProfileVariables()
    private let cardViewInstance = ExploreCategoryComponents()
    private let loginRegisterComponent = EditProfileVariables()
    private var emailFill : String!
    let storageRef = Storage.storage().reference()
    let kMinimumAccessibleButtonSize = CGSize(width: 64, height: 48)
    var extensions = ""
    var message = ""
    
    
    
//    let usernameController: MDCTextInputControllerFilled!
//    let emailController: MDCTextInputControllerFilled!
//    let passwordController: MDCTextInputControllerFilled!
//    let confirmPassController: MDCTextInputControllerFilled!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

//        AccountCreated = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupView()
        
     
        textFieldDelegate()
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        usernameController = MDCTextInputControllerFilled(textInput: loginRegisterComponent.usernameTextField)
//        emailController = MDCTextInputControllerFilled(textInput: loginRegisterComponent.emailTextField)
//        passwordController = MDCTextInputControllerFilled(textInput: loginRegisterComponent.currentPassword)
//        confirmPassController = MDCTextInputControllerFilled(textInput: loginRegisterComponent.passwordConfirmField)
//        
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
   // }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func textFieldDelegate() {
        hideKeyboardWhenTappedAround()
        loginRegisterComponent.usernameTextField.delegate = self
        loginRegisterComponent.emailTextField.delegate = self
        loginRegisterComponent.currentPassword.delegate = self
        loginRegisterComponent.passwordConfirmField.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.loginRegisterComponent.usernameTextField:
            loginRegisterComponent.emailTextField.becomeFirstResponder()
        
        case self.loginRegisterComponent.emailTextField:
            loginRegisterComponent.currentPassword.becomeFirstResponder()
        
        case self.loginRegisterComponent.currentPassword:
            loginRegisterComponent.passwordConfirmField.becomeFirstResponder()
        case self.loginRegisterComponent.passwordConfirmField:
            handleCreateAcc()
            self.view.endEditing(true)
        default:
            handleCreateAcc()
        }
        
        return true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.loginRegisterComponent.passwordConfirmField:
            loginRegisterComponent.passwordConfirmField.returnKeyType = UIReturnKeyType.go
        default:
            print("nothing...")
        }
        
    }
    
    func setupView() {
        
        view.addSubview(profileVariables.profileView)
        view.addSubview(detailProfileVariables.detailProfileView)
        
        self.constraintProfileView()
        self.constraintDetailProfileView()
            
        self.profileViewSubview()
        self.constraintImageUserProfileView()
        
        self.setupCreateAccountMainView ()

        self.setupButtonAction ()
    }
    
    func setupCreateAccountMainView () {
        
        view.addSubview(cardViewInstance.mainCardView)
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.createAccLabel)
        
        if getDeviceModelName.userDeviceIphone5() {
            
            NSLayoutConstraint.activate([
                
                cardViewInstance.mainCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
                cardViewInstance.mainCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                cardViewInstance.mainCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                cardViewInstance.mainCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2)
                
                ])
            
        } else {
            cardViewInstance.mainCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
            cardViewInstance.mainCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = false
            cardViewInstance.mainCardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2).isActive = false
            cardViewInstance.mainCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            cardViewInstance.mainCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            cardViewInstance.mainCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2.2).isActive = true
        }
        
        
        
        loginRegisterComponent.createAccLabel.topAnchor.constraint(equalTo: cardViewInstance.mainCardView.topAnchor, constant: 10).isActive = true
        loginRegisterComponent.createAccLabel.centerXAnchor.constraint(equalTo: cardViewInstance.mainCardView.centerXAnchor).isActive = true
        
        
        self.setupRegisterField()
    }
    
    func setupRegisterField () {
        
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.usernameTextField)
        
        
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.emailTextField)
        
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.currentPassword)
        
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.passwordConfirmField)
        
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.loginButton)
        
        self.constraintUsernameTextfield()
        self.constraintEmailTextField()
        self.constraintPasswordTextField()
        self.constraintConfirmPassword ()
        self.constraintLoginButton()
    }
    
    func constraintUsernameTextfield () {
        
        NSLayoutConstraint.activate([
            
            loginRegisterComponent.usernameTextField.topAnchor.constraint(equalTo: loginRegisterComponent.createAccLabel.bottomAnchor, constant: 10),
            loginRegisterComponent.usernameTextField.leadingAnchor.constraint(equalTo: cardViewInstance.mainCardView.leadingAnchor, constant: 20),
            loginRegisterComponent.usernameTextField.trailingAnchor.constraint(equalTo: cardViewInstance.mainCardView.trailingAnchor, constant: -20),
            loginRegisterComponent.usernameTextField.heightAnchor.constraint(equalTo: cardViewInstance.mainCardView.heightAnchor, multiplier: 1/7.5)
            
            ])
        
    }
    
    func constraintEmailTextField () {
        
        NSLayoutConstraint.activate([
            loginRegisterComponent.emailTextField.topAnchor.constraint(equalTo: loginRegisterComponent.usernameTextField.bottomAnchor, constant: 10),
            loginRegisterComponent.emailTextField.leadingAnchor.constraint(equalTo: loginRegisterComponent.usernameTextField.leadingAnchor),
            loginRegisterComponent.emailTextField.trailingAnchor.constraint(equalTo: loginRegisterComponent.usernameTextField.trailingAnchor),
            loginRegisterComponent.emailTextField.heightAnchor.constraint(equalTo: loginRegisterComponent.usernameTextField.heightAnchor)
            
            ])
  
    }
    func constraintPasswordTextField() {
        
        NSLayoutConstraint.activate([
            
            loginRegisterComponent.currentPassword.topAnchor.constraint(equalTo: loginRegisterComponent.emailTextField.bottomAnchor, constant: 10),
            loginRegisterComponent.currentPassword.leadingAnchor.constraint(equalTo: loginRegisterComponent.emailTextField.leadingAnchor),
            loginRegisterComponent.currentPassword.trailingAnchor.constraint(equalTo: loginRegisterComponent.emailTextField.trailingAnchor),
            loginRegisterComponent.currentPassword.heightAnchor.constraint(equalTo: loginRegisterComponent.emailTextField.heightAnchor)
            ])

    }
    func constraintConfirmPassword () {
        
        NSLayoutConstraint.activate([
            
            loginRegisterComponent.passwordConfirmField.topAnchor.constraint(equalTo: loginRegisterComponent.currentPassword.bottomAnchor, constant: 10),
            loginRegisterComponent.passwordConfirmField.leadingAnchor.constraint(equalTo: loginRegisterComponent.usernameTextField.leadingAnchor),
            loginRegisterComponent.passwordConfirmField.trailingAnchor.constraint(equalTo: loginRegisterComponent.usernameTextField.trailingAnchor),
            loginRegisterComponent.passwordConfirmField.heightAnchor.constraint(equalTo: loginRegisterComponent.emailTextField.heightAnchor)
            
            ])
        
    }
    func constraintLoginButton () {
        loginRegisterComponent.loginButton.setTitle("Create an Account", for: .normal)
        
        loginRegisterComponent.loginButton.topAnchor.constraint(equalTo: loginRegisterComponent.passwordConfirmField.bottomAnchor, constant: 10).isActive = true
        loginRegisterComponent.loginButton.leadingAnchor.constraint(equalTo: loginRegisterComponent.passwordConfirmField.leadingAnchor).isActive = true
        loginRegisterComponent.loginButton.trailingAnchor.constraint(equalTo: loginRegisterComponent.passwordConfirmField.trailingAnchor).isActive = true
        loginRegisterComponent.loginButton.heightAnchor.constraint(equalTo: cardViewInstance.mainCardView.heightAnchor, multiplier: 1/7.5).isActive = true
        

    }
    
    
    
    func setupButtonAction () {
        //registerAccBtn
        loginRegisterComponent.loginButton.addTarget(self, action: #selector(handleCreateAcc), for: .touchUpInside)
    }
  
    @objc func handleCreateAcc () {
      
        
        let lengthPassword : Int = (loginRegisterComponent.currentPassword.text?.count)!
        let lengthUsername: Int = (loginRegisterComponent.usernameTextField.text?.count)!
        
        let specialcharacters = UIComponentHelper.AvoidSpecialCharaters(specialcharaters: loginRegisterComponent.usernameTextField.text!)
        let countwhitespaces : Int = UIComponentHelper.Countwhitespece(_whitespece: loginRegisterComponent.usernameTextField.text!)
        
        if (loginRegisterComponent.usernameTextField.text?.isEmpty)! && (loginRegisterComponent.emailTextField.text?.isEmpty)! && (loginRegisterComponent.currentPassword.text?.isEmpty)! && (loginRegisterComponent.passwordConfirmField.text?.isEmpty)! {
            
           
            ProgressHUD.showError("Please enter your username.")
            
            return
        }
        if (loginRegisterComponent.usernameTextField.text?.isEmpty)! {
            
            ProgressHUD.showError("Please enter your username.")
            
            return
        }
        if (loginRegisterComponent.emailTextField.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your email.")
            return
        }
        if (loginRegisterComponent.currentPassword.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your password.")
            return
        }
        if (loginRegisterComponent.passwordConfirmField.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your confirm password.")
            return
        }
        if loginRegisterComponent.currentPassword.text != loginRegisterComponent.passwordConfirmField.text {
            ProgressHUD.showError("Your password doesn't match with your confirm password.")
            return
        } else if lengthPassword < 6 {
            ProgressHUD.showError("Please enter your password more than 6 characters.")
            return
        } else if lengthUsername < 5 {
            ProgressHUD.showError( "Please enter your name more than 6 characters.")
            return
        } else if lengthUsername > 30 {
            ProgressHUD.showError("Please enter your name less than 30 characters.")
            return
            
        } else if lengthPassword > 20 {
            ProgressHUD.showError("Please enter your password more than 20 characters.")
            return
        }else if specialcharacters == false {
            ProgressHUD.showError("Your username should not contain any special charaters or numbers.")
            return
        } else if countwhitespaces >= 3 {
            UIComponentHelper.showProgressError(status: "Your name should not contain more than 3 white spaces.")
            return
            
        }else {
            
            let whitespaceAtBeginning = UIComponentHelper.Whitespeceatbeginning(_whitespece: loginRegisterComponent.usernameTextField.text!)
            if whitespaceAtBeginning == true {
                //ProgressHUD.showError("Your name should not contain whitespace at the beginning.")
                return
            }
            InternetConnection.second = 0
            InternetConnection.countTimer.invalidate()
            ProgressHUD.show("Loading...", interaction: false)
            InternetConnection.CountTimer()
            
        createOneSwitch(email:loginRegisterComponent.emailTextField.text! ,name:loginRegisterComponent.usernameTextField.text!,  completionHandler: { result in
                
                if result {
                    
                    Auth.auth().createUser(withEmail: self.loginRegisterComponent.emailTextField.text!, password: self.loginRegisterComponent.currentPassword.text!, completion: { (user, error) in
                        UIComponentHelper.ProgressDismiss()
                        //EMAIL_AUTOFILL = self.loginRegisterComponent.emailTextField.text!
                        
                        if InternetConnection.second == 10 {
                            
                            InternetConnection.countTimer.invalidate()
                            InternetConnection.second = 0
                            UIComponentHelper.ProgressDismiss()
                            
                            return
                        }
                        InternetConnection.countTimer.invalidate()
                        InternetConnection.second = 0
                        if (error == nil) {
                            
                            let img = UIImage(named: "detailprofile-icon")
                            let imageProfile = UIImagePNGRepresentation(img!)
                            let riverRef = self.storageRef.child("userprofile-photo").child((user?.uid)!)
                            riverRef.putData(imageProfile!, metadata: nil, completion: { (metadata, error) in
                                
                                guard let metadata = metadata else {
                                    return
                                }
                                let downloadUrl = metadata.downloadURL()!.absoluteString
                                let url = NSURL(string: downloadUrl) as URL?
                                let changeProfileuser = user?.createProfileChangeRequest()
                                changeProfileuser?.photoURL = url
                                changeProfileuser?.displayName = self.loginRegisterComponent.usernameTextField.text
                                changeProfileuser?.commitChanges(completion: { (error) in
                                    if error != nil {
                                        self.PresentAlertController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                    }
                                })
                                
                                
                            })
                            
                            self.addVOIPdataTofireStore(uid: (Auth.auth().currentUser?.uid)!, email: self.loginRegisterComponent.emailTextField.text! )
                            
                            
                            
                            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                if error != nil {
                                    ProgressHUD.showError(error?.localizedDescription)
                                }
                            })
                            ProgressHUD.dismiss()
                            
                            let userInput = UserModel(extension: "", password: self.loginRegisterComponent.currentPassword.text!, username: self.loginRegisterComponent.usernameTextField.text!, email: (self.loginRegisterComponent.emailTextField.text?.capitalizingFirstLetter())!)
                            FIRFireStoreService.shared.createUserFirestore(for: userInput, in: .users, completion: { (done) in
                                if done {
                                    print("Done")
                                    self.presentDialogActionController(title: "Email Verification", message: "We have sent a confirmation email. Please check your email and verify to continue.", avoidLeaving: false, gesture: false)
                                } else {
                                    self.presentDialogActionController(title: "Error", message: "Your account cannot be created. Please try again.", avoidLeaving: false, gesture: false)
                                }
                            })
                            
                        } else {
                            ProgressHUD.dismiss()
                            let check: String = (error?.localizedDescription)!
                            
                            switch check {
                            case "The email address is badly formatted.":
                                ProgressHUD.showError("Please provide a valid form of email address.")
                                break
                            case "The email address is already in use by another account":
                                ProgressHUD.showError("Your email is already in used by another account. Please try another email.")
                                
                                break
                            default:
                                self.PresentDialogOneActionController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                                break
                                
                            }
                            
                            
                        }
                        
                        
                    })
                    
                    
                } else {
                    
                    ProgressHUD.showError("Your email is already in used by another account. Please try another email.")
                }
                
            })
      
            
            print("You have completed the requirement.")
        }
        
        
        
        
    }
    
    
    

    func setupNavigation() {
        view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-icon"), style: .plain, target: self, action: #selector(backToLogin))
    }
    @objc
    func backToLogin () {
        
        if (loginRegisterComponent.currentPassword.text?.isEmpty == false) || (loginRegisterComponent.usernameTextField.text?.isEmpty == false ) || (loginRegisterComponent.emailTextField.text?.isEmpty == false) || (loginRegisterComponent.passwordConfirmField.text?.isEmpty == false) {
            
            self.presentDialogActionController(title: "Warning", message: "Are you sure want to leave? This will not save your information.", avoidLeaving: true, gesture: true)
            
        }else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    func presentDialogActionController(title: String, message: String, avoidLeaving: Bool, gesture: Bool) {
        
        
        
        let popupDialogController = PopupDialog(title: title, message: message)
        
        if avoidLeaving {
            
            let okayButton = DefaultButton(title: "Yes") {
                self.navigationController?.popToRootViewController(animated: true)
            }
            let cancelButton = CancelButton(title: "No") {
                
            }
            
            popupDialogController.addButtons([okayButton, cancelButton])
        } else {
            
            let okayButton = DefaultButton(title: "Okay") {
                print("Okay Button")
                
//                AccountCreated = true
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            
            popupDialogController.addButton(okayButton)
            
        }
        
        
        
        self.present(popupDialogController, animated: true, completion: nil)
        
    }
    
    func createOneSwitch(email:String,name: String, completionHandler: @escaping (Bool) -> Void)  {
        
        var request = URLRequest(url: URL(string:"https://os.keen-vc.cf/api/v2/onecore/u-exts" )!)
        request.httpMethod = "POST"
       
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic NWI4ZTkwOTRiZDJmMDcxODU2MzFjMWY0OmV5SmhiR2NpT2lKSVV6STFOaUlzSW5SNWNDSTZJa3BYVkNKOS5leUp5YjJ4bElqb2lRVkJRSWl3aVgybGtJam9pTldJNFpUa3dPVFJpWkRKbU1EY3hPRFUyTXpGak1XWTBJaXdpYzJOdmNHVWlPaUpXUzBOTVZVSTZVa1ZCUkNJc0ltRndjQ0k2SWxaTFEweFZRaUlzSW1Oc2FXVnVkQ0k2SWtaSlVsTlVJaXdpYTJWNVgybGtJam9pVFdGamFua3dkRFkxT1c5T1pYZEdjbUZJU2s1NWVHTTNNV1JRV2xwalNsa3hNbE5wYm01UFYwcHJkRUo0TkhsdFEzcExSMnRQU0drNU5uSXdZakZEYnpKYWMzQlNUVU5KYWtsc01IUklPSGR2VGpkeGNHRjJkazVqZUhkVGNrNUJRa1YwTDFGWVkxZHhPRlV4UlZJMU1GUnBZMWREYjJ0NmFuUmtWMnhuWjFsQ2JXOUtaRzFuY21WeFFsTmxNWE0zV21sRFVVNUdiVWR4WTNJeE1pc3hVVFpPTlVaM1NtZ3hURFJuVlZoS2NXUXhhR0ZxUzJOalpHTlBjaTk1TWxNNWJUWXZiWEZJUkdNM1Vsa3lWbm9yWkVWdFlXZERUelJYVEZKMFlVOUxabXBpZFRWNVZtNHdRMlpCUVZCMFZHMDRja3hEZUhrNFJsWldVell2TVc4MWNtNHdiSFJ0T0dSR1ZVMU9TMDFSZUdOWFdUVTVWa05KYVV0S2FGcEJUVlJDU2tKNU5FNWxMMU1yY0hoUFpHRjViVXBWZVdrMFkyOUdaSGRFVTNFNFF6VXdTSGRpYjJoS01ucEtVMnR3WjBOeVlWUXdiR3BCUFQwaUxDSnBjM04xWlY5emRHRnRjQ0k2TVRVek5qQTJPVGM0TURreE1Td2lhV0YwSWpveE5UTTJNRFk1Tnpnd0xDSnVZbVlpT2pFMU16WXdOamszT0RVc0ltVjRjQ0k2TVRVNU9URTBNVGM0TUN3aVlYVmtJam9pUVZCUUlpd2lhWE56SWpvaWIyNWxjM2RwZEdOb0lpd2ljM1ZpSWpvaVZrdERURlZDUUc5dVpYTjNhWFJqYUNJc0ltcDBhU0k2SWpWaU9HVTVNRGswWW1ReVpqQTNNVGcxTmpNeFl6Rm1OQ0o5Ljl5VmhUaVVraWE0TTc3RzNhLUpsaVBxdm5GRFEtRWk2YVFCT192MVpHYVk=" ,forHTTPHeaderField: "OS-API-KEY")
        
        let parameters = ["domain":"192.168.7.136" , "extPassword":["type":"raw","pass":"VoIP125*KIT"] ,"email": email,"password":"VoIP125*KIT","vmPassword":"12356","metadata":["firstName":name,"lastName": name,"dob":"12-12-1998"],"scope":"WRITE+DELETE"] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                self.message = (error?.localizedDescription)!
                completionHandler(false)
            } else {
                
                do {
                    
                    var json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                    
                  
                    
                    if json!["success"] as! Bool == true {
                        let data = json!["data"] as! [String : Any]
                        let ext = data["ext"] as! [String: Any]
                        self.extensions = ext["extension"] as! String
                        completionHandler(true)
                    } else {
                        self.message = json!["message"] as! String
                        completionHandler(false)
                        
                    }
                    
                    
                } catch {
                    
                    print("eror")
                }
                
            }
        }
        
        
        
        task.resume()
        
        
      
    }
    
    func addVOIPdataTofireStore(uid: String , email: String) {
        db.collection("users").document(uid).setData(
        
            [
                "email" : email,
                "extension" : extensions,
                "password" : "VoIP125*KIT"
            ]
        )
        
    }
    
}
extension CreateAccountController {
    
    func constraintProfileView() {
        
        profileVariables.profileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileVariables.profileView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileVariables.profileView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileVariables.profileView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        profileVariables.profileView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        profileVariables.profileView.backgroundColor = .red
        
    }
    func constraintDetailProfileView() {
        
        detailProfileVariables.detailProfileView.topAnchor.constraint(equalTo: profileVariables.profileView.bottomAnchor).isActive = true
        detailProfileVariables.detailProfileView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        detailProfileVariables.detailProfileView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailProfileVariables.detailProfileView.backgroundColor = .white
        
        
    }
    
    func profileViewSubview() {
        
        profileVariables.profileView.addSubview(profileVariables.imageUser)
        profileVariables.imageUser.addSubview(profileVariables.opacityDetailEachExplore)
        
        profileVariables.opacityDetailEachExplore.topAnchor.constraint(equalTo: profileVariables.imageUser.topAnchor).isActive = true
        profileVariables.opacityDetailEachExplore.leftAnchor.constraint(equalTo: profileVariables.imageUser.leftAnchor).isActive = true
        profileVariables.opacityDetailEachExplore.rightAnchor.constraint(equalTo: profileVariables.imageUser.rightAnchor).isActive = true
        profileVariables.opacityDetailEachExplore.heightAnchor.constraint(equalTo: profileVariables.profileView.heightAnchor).isActive = true
        
    }
    
    func constraintImageUserProfileView() {
        
        profileVariables.imageUser.topAnchor.constraint(equalTo: profileVariables.profileView.topAnchor).isActive = true
        profileVariables.imageUser.leftAnchor.constraint(equalTo: profileVariables.profileView.leftAnchor).isActive = true
        profileVariables.imageUser.rightAnchor.constraint(equalTo: profileVariables.profileView.rightAnchor).isActive = true
        profileVariables.imageUser.heightAnchor.constraint(equalTo: profileVariables.profileView.heightAnchor).isActive = true
        
    }
    
    
}
