//
//  ResetPasswordViewController.swift
//  vKclub
//
//  Created by Pisal on 8/9/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import SVProgressHUD
import ProgressHUD
import Firebase
import PopupDialog

class ResetPasswordViewController : UIViewController , UITextFieldDelegate{
    
    let userProfileInstance = DetailProfileVariables()
    let resetPasswordInstance = EditProfileVariables()
    let cardViewInstance = ExploreCategoryComponents()
    lazy var currentUser = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        self.SetupNavigationItem()
        self.SetupBackgroundView()
        self.SetupResetPasswordView()
        self.SetupPasswordTextField ()
        resetPasswordInstance.currentPassword.delegate = self
        resetPasswordInstance.newPasswordField.delegate = self
        resetPasswordInstance.passwordConfirmField.delegate = self
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.resetPasswordInstance.currentPassword:
            self.resetPasswordInstance.newPasswordField.becomeFirstResponder()
        case self.resetPasswordInstance.newPasswordField:
            self.resetPasswordInstance.passwordConfirmField.becomeFirstResponder()
        case self.resetPasswordInstance.passwordConfirmField:
            handleResetPassButton()
            self.view.endEditing(true)
        default:
            handleResetPassButton()
        }
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.resetPasswordInstance.passwordConfirmField:
            resetPasswordInstance.passwordConfirmField.returnKeyType = UIReturnKeyType.go
        default:
            print("======fasdf=====")
        }
    
    }
    
    func SetupNavigationItem () {
        self.navigationItem.title = "Reset Password"

        
    }
    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: {
            
        })
    }
    
    
}

extension ResetPasswordViewController {
    
    func SetupBackgroundView (){
        self.view.addSubview(userProfileInstance.simepleView)
        userProfileInstance.simepleView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        userProfileInstance.simepleView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        userProfileInstance.simepleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3.3).isActive = true
    }
    func SetupResetPasswordView () {
        
        self.view.addSubview(cardViewInstance.mainCardView)
        self.cardViewInstance.mainCardView.addSubview(resetPasswordInstance.resetPassLabel)
        
        cardViewInstance.mainCardView.topAnchor.constraint(equalTo: userProfileInstance.simepleView.bottomAnchor, constant: -50).isActive = true
        cardViewInstance.mainCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cardViewInstance.mainCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        cardViewInstance.mainCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2.7).isActive = true
        
        resetPasswordInstance.resetPassLabel.topAnchor.constraint(equalTo: cardViewInstance.mainCardView.topAnchor, constant: 10).isActive = true
        resetPasswordInstance.resetPassLabel.centerXAnchor.constraint(equalTo: cardViewInstance.mainCardView.centerXAnchor).isActive = true
        
        
    }
    
    func SetupPasswordTextField () {
        
        cardViewInstance.mainCardView.addSubview(resetPasswordInstance.currentPassword)
        
        cardViewInstance.mainCardView.addSubview(resetPasswordInstance.newPasswordField)
        
        cardViewInstance.mainCardView.addSubview(resetPasswordInstance.passwordConfirmField)
        
        
        cardViewInstance.mainCardView.addSubview(resetPasswordInstance.resetPasswordButton)
        
        
        self.ConstraintCurrentPassword()
        self.ConstraintNewPassword()
        self.ConstraintConPassword()
        self.ConstraintResetPassBtn()
    }
    func ConstraintCurrentPassword() {
        
        resetPasswordInstance.currentPassword.topAnchor.constraint(equalTo: resetPasswordInstance.resetPassLabel.bottomAnchor, constant: 10).isActive = true
        resetPasswordInstance.currentPassword.leadingAnchor.constraint(equalTo: cardViewInstance.mainCardView.leadingAnchor, constant: 20).isActive = true
        resetPasswordInstance.currentPassword.trailingAnchor.constraint(equalTo: cardViewInstance.mainCardView.trailingAnchor, constant: -20).isActive = true
        resetPasswordInstance.currentPassword.heightAnchor.constraint(equalTo: cardViewInstance.mainCardView.heightAnchor, multiplier: 1/5.9).isActive = true
        
        
    }
    func ConstraintNewPassword() {
        
        resetPasswordInstance.newPasswordField.topAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.bottomAnchor, constant: 10).isActive = true
        resetPasswordInstance.newPasswordField.leadingAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.leadingAnchor).isActive = true
        resetPasswordInstance.newPasswordField.trailingAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.trailingAnchor).isActive = true
        resetPasswordInstance.newPasswordField.heightAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.heightAnchor).isActive = true
        
        
    }
    func ConstraintConPassword () {
        
        resetPasswordInstance.passwordConfirmField.topAnchor.constraint(equalTo: resetPasswordInstance.newPasswordField.bottomAnchor, constant: 10).isActive = true
        resetPasswordInstance.passwordConfirmField.leadingAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.leadingAnchor).isActive = true
        resetPasswordInstance.passwordConfirmField.trailingAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.trailingAnchor).isActive = true
        resetPasswordInstance.passwordConfirmField.heightAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.heightAnchor).isActive = true
    
    }
    func ConstraintResetPassBtn () {
        
        resetPasswordInstance.resetPasswordButton.topAnchor.constraint(equalTo: resetPasswordInstance.passwordConfirmField.bottomAnchor, constant: 10).isActive = true
        resetPasswordInstance.resetPasswordButton.leadingAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.leadingAnchor).isActive = true
        resetPasswordInstance.resetPasswordButton.trailingAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.trailingAnchor).isActive = true
        resetPasswordInstance.resetPasswordButton.heightAnchor.constraint(equalTo: resetPasswordInstance.currentPassword.heightAnchor).isActive = true
        
        resetPasswordInstance.resetPasswordButton.addTarget(self, action: #selector(handleResetPassButton), for: .touchUpInside)
        
    }
    @objc
    func handleResetPassButton() {
        
        print("reseting password")
        if (resetPasswordInstance.currentPassword.text?.isEmpty)! && (resetPasswordInstance.newPasswordField.text?.isEmpty)! && (resetPasswordInstance.newPasswordField.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your data")
            return
        }
        if (resetPasswordInstance.newPasswordField.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your new password")
            return
        }
        if (resetPasswordInstance.passwordConfirmField.text?.isEmpty)! {
            ProgressHUD.showError("Please enter your confirm password")
            return
        }
        if resetPasswordInstance.newPasswordField.text != resetPasswordInstance.passwordConfirmField.text {
            ProgressHUD.showError("Your password doesn't match with confirm password")
            return
        } else {
            
            SVProgressShowLoading()
            let lengthPassword: Int = (resetPasswordInstance.newPasswordField.text?.count)!
            let lengthCurrentPass : Int = (resetPasswordInstance.currentPassword.text?.count)!
            if lengthPassword < 6 || lengthCurrentPass < 6 {
                SVProgressDismiss()
                ProgressHUD.showError("Please enter your password more than 6 characters")
                return
            }
        
            let credential = EmailAuthProvider.credential(withEmail: (currentUser?.email)!, password: self.resetPasswordInstance.currentPassword.text!)
            currentUser?.reauthenticate(with: credential, completion: { (error) in
                
                if error == nil {
                    self.SVProgressDismiss()
                    self.currentUser?.updatePassword(to: self.resetPasswordInstance.newPasswordField.text!, completion: { (error) in
                        if error == nil {
                            self.resetPasswordInstance.currentPassword.text = ""
                            self.resetPasswordInstance.newPasswordField.text = ""
                            self.resetPasswordInstance.passwordConfirmField.text = ""
                            self.alertConfirmPassChange()
                        } else {
                            self.PresentDialogOneActionController(title: "Warning", message: (error?.localizedDescription)!, actionTitle: "Okay")
                            return
                        }
                    })
                } else  {
                    self.SVProgressDismiss()
                    let check : String = (error?.localizedDescription)!
                    
                    switch check{
                    case "The password is invalid or the user does not have a password.":
                        self.PresentDialogOneActionController(title: "Error", message: "Please provide a valid password.", actionTitle: "Okay")
                        break
                    default:
                        self.PresentDialogOneActionController(title: "Something went wrong", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        
                        break
                    }
                    return
                }
            })
            
            
        }
        
        
    }
    
    func alertConfirmPassChange () {
        CustomPopupDialogView()
        let alert = PopupDialog(title: "Done", message: "Your password has been updated", image: nil, buttonAlignment: .horizontal, transitionStyle: PopupDialogTransitionStyle.bounceUp, preferredWidth: self.view.frame.width / 1.3, gestureDismissal: false, hideStatusBar: false) {
//            USER_RESET_PASS = true
        }
        let okayButton = DefaultButton(title: "Okay") {
            self.dismiss(animated: true, completion: {
                
            })
        }
        
        alert.addButton(okayButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
