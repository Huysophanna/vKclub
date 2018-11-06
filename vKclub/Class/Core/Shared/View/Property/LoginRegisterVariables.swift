//
//  MembershipDetailVariable.swift
//  vKclub
//
//  Created by Pisal on 7/16/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer

import JVFloatLabeledTextField

class EditProfileVariables {
    
    struct Constant {
        
        static let typeName = "Username"
        static let typePass = "Password"
        static let typeNewPass = "New Password"
        static let typeConfirmPass = "Confirm Password"
        static let typeEmail = "Email"
        static let saveBtn = "Save"
        static let loginLabel = "Login"
        static let createAccountLabel = "Create Account"
        static let forgotPasswordLabel = "Forgot Password"
        static let createAccButton = "Create a new Account"
        static let createAccRegisterBtn = "Create an Account"
        static let forgotPasswordButton = "Forgot Password?"
        static let resetPassBtn = "Save"
        static let resetPassButton = "Reset Password"
        static let resetPssLabel = "Reset Password"
    }
    lazy var loginLabel: UILabel = EditProfileVariables.getLabelRegister(title: Constant.loginLabel)
    lazy var createAccLabel: UILabel = EditProfileVariables.getLabelRegister(title: Constant.createAccountLabel)
    lazy var resetPassLabel: UILabel = EditProfileVariables.getLabelRegister(title: Constant.resetPssLabel)
    lazy var forgotPasslabel: UILabel = EditProfileVariables.getLabelRegister(title: Constant.forgotPasswordLabel)
    
    lazy var usernameTextField: JVFloatLabeledTextField = EditProfileVariables.getTextField(type: Constant.typeName)
    lazy var emailTextField: JVFloatLabeledTextField = EditProfileVariables.getTextField(type: Constant.typeEmail)
    lazy var currentPassword: JVFloatLabeledTextField = EditProfileVariables.getTextField(type: Constant.typePass)
    lazy var passwordConfirmField: JVFloatLabeledTextField = EditProfileVariables.getTextField(type: Constant.typeConfirmPass)
    lazy var newPasswordField: JVFloatLabeledTextField = EditProfileVariables.getTextField(type: Constant.typeNewPass)

    
    lazy var loginButton: MDCButton = EditProfileVariables.getUIButton(title: Constant.loginLabel)
    lazy var forgotPasswordButton: MDCButton = EditProfileVariables.getUIButton(title: Constant.forgotPasswordButton)
    lazy var createAccButton: MDCButton = EditProfileVariables.getUIButton(title: Constant.createAccButton)
    lazy var registerAccBtn: MDCButton = EditProfileVariables.getUIButton(title: Constant.createAccRegisterBtn)
    lazy var resetPassBtn : MDCButton = EditProfileVariables.getUIButton(title: Constant.resetPassButton)
    lazy var editSaveBtton: MDCButton = EditProfileVariables.getUIButton(title: Constant.saveBtn)
    lazy var resetPasswordButton: MDCButton = EditProfileVariables.getUIButton(title: Constant.resetPassBtn)
}
extension EditProfileVariables {
    
    static func getLabelRegister(title: String) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFCompactText-Bold", size: 22)
        label.text = title
        label.textColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
        return label
    }
    
    static func getTextField(type: String) -> JVFloatLabeledTextField {
        
        let textField = JVFloatLabeledTextField()
        //textField.borderColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
    
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0).cgColor
        if type == Constant.typePass || type == Constant.typeConfirmPass || type == Constant.typeNewPass{
            textField.isSecureTextEntry = true
            textField.placeholder = type
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        }
        if type == Constant.typeEmail{
            textField.placeholder = type
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        if type == Constant.typeName {
            textField.placeholder = type
            textField.keyboardType = UIKeyboardType.alphabet
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "SFCompactText-Regular", size: 16)
        return textField
        
    }
    static func getSeparateView () -> UIView{
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func getUIButton(title: String) -> MDCButton {
        
        let containedButton = MDCButton()
//        containedButton.isOpaque = false
        let buttonScheme = MDCButtonScheme()
        if let customFont = UIFont(name:"SFCompactText-Regular", size:16.0) {
            let typographyScheme = MDCTypographyScheme()
            typographyScheme.button = customFont
            buttonScheme.typographyScheme = typographyScheme
        }
        containedButton.setTitle(title, for: .normal)
        containedButton.sizeToFit()
        containedButton.translatesAutoresizingMaskIntoConstraints = false
        
        if title == Constant.loginLabel || title == Constant.createAccRegisterBtn || title == Constant.saveBtn || title == Constant.resetPassBtn {
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: containedButton)
            containedButton.setTitleColor(UIColor.white, for: .normal)
            containedButton.backgroundColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
            containedButton.setElevation(ShadowElevation.none, for: .normal)
            containedButton.setShadowColor(UIColor.white, for: .normal)
            containedButton.titleLabel?.textAlignment = .left
        } else {
            
            if title == Constant.forgotPasswordButton || title == Constant.resetPassButton{
                if let customFont = UIFont(name:"SFCompactText-Bold", size:14.0) {
                    let typographyScheme = MDCTypographyScheme()
                    typographyScheme.button = customFont
                    buttonScheme.typographyScheme = typographyScheme
                }
                
                MDCOutlinedButtonThemer.applyScheme(buttonScheme, to: containedButton)
                
            }else {
                if let customFont = UIFont(name:"SFCompactText-Bold", size:16.0) {
                    let typographyScheme = MDCTypographyScheme()
                    typographyScheme.button = customFont
                    buttonScheme.typographyScheme = typographyScheme
                }
                MDCOutlinedButtonThemer.applyScheme(buttonScheme, to: containedButton)
                
            }
            containedButton.setTitleColor(UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0), for: .normal)
            containedButton.backgroundColor = .white
        }
        
        return containedButton
        
//        let button = UIButton()
//        button.setTitle(title, for: .normal)
//        button.titleLabel?.font = UIFont(name: "SFCompactText-Regular", size: 16)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        if title == Constant.loginLabel || title == Constant.createAccRegisterBtn || title == Constant.saveBtn || title == Constant.resetPassBtn{
//            button.setTitleColor(UIColor.white, for: .normal)
//            button.backgroundColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
//            button.layer.cornerRadius = 5
//            button.titleLabel?.textAlignment = .left
//        }
//        else {
//
//            button.setTitleColor(UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0), for: .normal)
//            button.backgroundColor = .white
//
//            if title == Constant.forgotPasswordButton || title == Constant.resetPassButton{
//
//                button.titleLabel?.font = UIFont(name: "SFCompactText-Bold", size: 14)
//            }else {
//                button.titleLabel?.font = UIFont(name: "SFCompactText-Bold", size: 16)
//            }
//
//        }
//
//
//        return button
    }
    
}

