//
//  ForgotPWController.swift
//  vKclub
//
//  Created by HuySophanna on 2/6/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import UIKit

class ForgotPWController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MakeWhiteBorderBtn(button: signUpBtn)
        MakeWhiteBorderBtn(button: backBtn)
        MakeWhitePlaceholder(textfield: nameTextField, name: "Name")
        
    }
    
    @IBAction func BackBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func MakeWhiteBorderBtn(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func MakeWhitePlaceholder(textfield: UITextField, name: String) {
        textfield.attributedPlaceholder = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
}
