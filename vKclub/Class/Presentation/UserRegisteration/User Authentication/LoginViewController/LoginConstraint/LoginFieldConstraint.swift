//
//  ConstraintLoginField.swift
//  vKclub
//
//  Created by Pisal on 8/3/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit

// Constraint Login Field
extension LoginViewController {
    
    func setupLoginMainView () {
        view.addSubview(cardViewInstance.mainCardView)
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.loginLabel)
        
        if getDeviceModelName.userDeviceIphone5() {
            NSLayoutConstraint.activate([
                cardViewInstance.mainCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
                cardViewInstance.mainCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                cardViewInstance.mainCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                cardViewInstance.mainCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                cardViewInstance.mainCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2.1)
                ])
        } else {
            cardViewInstance.mainCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
            cardViewInstance.mainCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            cardViewInstance.mainCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            cardViewInstance.mainCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            cardViewInstance.mainCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2.5).isActive = true
        }
        
        
        
        
        loginRegisterComponent.loginLabel.topAnchor.constraint(equalTo: cardViewInstance.mainCardView.topAnchor, constant: 10).isActive = true
        
        loginRegisterComponent.loginLabel.centerXAnchor.constraint(equalTo: cardViewInstance.mainCardView.centerXAnchor).isActive = true
        
        self.setupLoginField()
    }
    
    func setupLoginField () {
        
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.emailTextField)
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.currentPassword)
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.loginButton)
        
        self.constraintEmailTextField()
        self.constraintPasswordTextField()
        self.constraintLoginButton()
    }
    
    
    
    func constraintEmailTextField () {
        loginRegisterComponent.emailTextField.topAnchor.constraint(equalTo: loginRegisterComponent.loginLabel.bottomAnchor, constant: 10).isActive = true
        loginRegisterComponent.emailTextField.leftAnchor.constraint(equalTo: cardViewInstance.mainCardView.leftAnchor, constant: 20).isActive = true
        loginRegisterComponent.emailTextField.rightAnchor.constraint(equalTo: cardViewInstance.mainCardView.rightAnchor, constant: -20).isActive = true
        loginRegisterComponent.emailTextField.heightAnchor.constraint(equalTo: cardViewInstance.mainCardView.heightAnchor, multiplier: 1/5).isActive = true
     
    }
    func constraintPasswordTextField() {
        loginRegisterComponent.currentPassword.topAnchor.constraint(equalTo: loginRegisterComponent.emailTextField.bottomAnchor, constant: 10).isActive = true
        loginRegisterComponent.currentPassword.leftAnchor.constraint(equalTo: cardViewInstance.mainCardView.leftAnchor, constant: 20).isActive = true
        loginRegisterComponent.currentPassword.rightAnchor.constraint(equalTo: cardViewInstance.mainCardView.rightAnchor, constant: -20).isActive = true
        loginRegisterComponent.currentPassword.heightAnchor.constraint(equalTo: cardViewInstance.mainCardView.heightAnchor, multiplier: 1/5).isActive = true
 
    }
    
    func constraintLoginButton () {
        
        loginRegisterComponent.loginButton.topAnchor.constraint(equalTo: loginRegisterComponent.currentPassword.bottomAnchor, constant: 10).isActive = true
        loginRegisterComponent.loginButton.leftAnchor.constraint(equalTo: loginRegisterComponent.currentPassword.leftAnchor).isActive = true
        loginRegisterComponent.loginButton.rightAnchor.constraint(equalTo: loginRegisterComponent.currentPassword.rightAnchor).isActive = true
        loginRegisterComponent.loginButton.heightAnchor.constraint(equalTo: cardViewInstance.mainCardView.heightAnchor, multiplier: 1/6).isActive = true
        
        
//        loginRegisterComponent.loginButton.minimumSize = CGSize(width: 64, height: 48)
    }
    
    func setupForgotPasswordButton () {
        cardViewInstance.mainCardView.addSubview(loginRegisterComponent.forgotPasswordButton)
        loginRegisterComponent.forgotPasswordButton.bottomAnchor.constraint(equalTo: cardViewInstance.mainCardView.bottomAnchor, constant: -10).isActive = true
        loginRegisterComponent.forgotPasswordButton.leftAnchor.constraint(equalTo: loginRegisterComponent.currentPassword.leftAnchor).isActive = true
        loginRegisterComponent.forgotPasswordButton.rightAnchor.constraint(equalTo: loginRegisterComponent.currentPassword.rightAnchor).isActive = true
        loginRegisterComponent.forgotPasswordButton.heightAnchor.constraint(equalTo: loginRegisterComponent.createAccButton.heightAnchor).isActive = true
    }
    
    func constraintCreateAcc () {
        loginRegisterComponent.createAccButton.leftAnchor.constraint(equalTo: cardViewInstance.mainCardView.leftAnchor).isActive = true
        loginRegisterComponent.createAccButton.rightAnchor.constraint(equalTo: cardViewInstance.mainCardView.rightAnchor).isActive = true
        loginRegisterComponent.createAccButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        loginRegisterComponent.createAccButton.heightAnchor.constraint(equalTo: loginRegisterComponent.loginButton.heightAnchor, multiplier: 1/1.5).isActive = true
        
        //print("Height of card view in login field ", cardViewInstance.mainCardView.frame.size.height)
    }
}
