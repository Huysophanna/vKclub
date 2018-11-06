//
//  ForgotPasswordViewController.swift
//  vKclub
//
//  Created by Pisal on 7/31/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ProgressHUD
import PopupDialog

class ForgotPasswordViewController: UIViewController , UITextFieldDelegate{
    
    
    private let profileVariables = ProfileOverlayNavigationBar()
    private let detailProfileVariables = DetailProfileVariables()
    private let forgotPassComponent = EditProfileVariables()
    private let cardViewInstance = ExploreCategoryComponents()
    private let currentUser = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        view.addSubview(profileVariables.profileView)
        view.addSubview(detailProfileVariables.detailProfileView)
        
        self.constraintProfileView()
        self.constraintDetailProfileView()
        
        
        self.profileViewSubview()
        self.constraintImageUserProfileView()
        
        self.setupForgotPasswordView()
        
        forgotPassComponent.emailTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.forgotPassComponent.emailTextField:
            handleSubmitBtn()
            self.view.endEditing(true)
        default:
            handleSubmitBtn()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.forgotPassComponent.emailTextField:
            
            forgotPassComponent.emailTextField.returnKeyType = UIReturnKeyType.go
        default:
            print("nothing....")
        }
        
    }
    
    @objc
    func handleSubmitBtn() {
    
        print("submitting...")
  
            
            print("User availability....")
            if (forgotPassComponent.emailTextField.text?.isEmpty)! {
                ProgressHUD.showError("Please enter your email.")
                return
            } else {
                UIComponentHelper.showProgressWith(status: "Loading...", interact: false)
                Auth.auth().fetchProviders(forEmail: forgotPassComponent.emailTextField.text!, completion: { (emailData, error) in
                    if error == nil {
                        
                        if emailData == nil {
                            UIComponentHelper.ProgressDismiss()
                            self.PresentDialogOneActionController(title: "Warning", message: "Email you entered doesn't match with our records. Please re-check and try again.", actionTitle: "Okay")
                            return
                        } else {
                            
                            InternetConnection.CountTimer()
                            
                            Auth.auth().sendPasswordReset(withEmail: self.forgotPassComponent.emailTextField.text!, completion: { (error) in
                                if InternetConnection.second == 10 {
                                    InternetConnection.countTimer.invalidate()
                                    InternetConnection.second = 0
                                    UIComponentHelper.ProgressDismiss()
                                    return
                                }
                                InternetConnection.countTimer.invalidate()
                                InternetConnection.second = 0
                                if let error = error {
                                    self.PresentDialogOneActionController(title: "Error", message: error.localizedDescription, actionTitle: "Okay")
                                
                                } else {
                                    UIComponentHelper.ProgressDismiss()
                                    self.PresentDialogOneActionController(title: "Success", message: "Please check your email to recover your password.", actionTitle: "Okay")
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }
                            })
                            
                        }
                        
                    } else {
                        
                        UIComponentHelper.ProgressDismiss()
                        self.PresentDialogOneActionController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                        
                    }
                })
            }
            
       
        
    }
    
    
}
extension ForgotPasswordViewController {
    
    
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
    
    func setupForgotPasswordView () {
        view.addSubview(cardViewInstance.mainCardView)
        cardViewInstance.mainCardView.addSubview(forgotPassComponent.forgotPasslabel)
        
        cardViewInstance.mainCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        cardViewInstance.mainCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardViewInstance.mainCardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2).isActive = true
        cardViewInstance.mainCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4.2).isActive = true
        
        
        forgotPassComponent.forgotPasslabel.topAnchor.constraint(equalTo: cardViewInstance.mainCardView.topAnchor, constant: 10).isActive = true
        forgotPassComponent.forgotPasslabel.centerXAnchor.constraint(equalTo: cardViewInstance.mainCardView.centerXAnchor).isActive = true
        
        self.setupEmailField()
        
    }
    
    
    func setupEmailField() {
        
        cardViewInstance.mainCardView.addSubview(forgotPassComponent.emailTextField)
        cardViewInstance.mainCardView.addSubview(forgotPassComponent.editSaveBtton)
        forgotPassComponent.editSaveBtton.setTitle("Submit", for: .normal)
        
        // Constraint email text field
        NSLayoutConstraint.activate([
            forgotPassComponent.emailTextField.topAnchor.constraint(equalTo: forgotPassComponent.forgotPasslabel.bottomAnchor, constant: 10),
            forgotPassComponent.emailTextField.leftAnchor.constraint(equalTo: cardViewInstance.mainCardView.leftAnchor, constant: 10),
            forgotPassComponent.emailTextField.rightAnchor.constraint(equalTo: cardViewInstance.mainCardView.rightAnchor, constant: -10),
            forgotPassComponent.emailTextField.heightAnchor.constraint(equalTo: cardViewInstance.mainCardView.heightAnchor, multiplier: 1/3.8)
            ])
        
       
        // Constraint action button
        NSLayoutConstraint.activate([
            forgotPassComponent.editSaveBtton.topAnchor.constraint(equalTo: forgotPassComponent.emailTextField.bottomAnchor, constant: 10),
            forgotPassComponent.editSaveBtton.leftAnchor.constraint(equalTo: forgotPassComponent.emailTextField.leftAnchor),
            forgotPassComponent.editSaveBtton.rightAnchor.constraint(equalTo: forgotPassComponent.emailTextField.rightAnchor),
            forgotPassComponent.editSaveBtton.heightAnchor.constraint(equalTo: forgotPassComponent.emailTextField.heightAnchor)
            ])
        
        forgotPassComponent.editSaveBtton.addTarget(self, action: #selector(handleSubmitBtn), for: .touchUpInside)
    }
}
