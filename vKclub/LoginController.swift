//
//  LoginController.swift
//  vKclub
//
//  Created by HuySophanna on 30/5/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInFBBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        MakeLeftViewIconToTextField(textField: emailTextField, icon: "user_left_icon.png")
        
        MakeLeftViewIconToTextField(textField: pwTextField, icon: "pw_icon.png")
        
        MakeBorderTransparentBtn(button: signInBtn)
        MakeFBBorderBtn(button: signInFBBtn)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func MakeBorderTransparentBtn(button: UIButton) {
        
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        button.layer.cornerRadius = 5
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
  
}
