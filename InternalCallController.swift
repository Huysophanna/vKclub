//
//  InternalCallController.swift
//  vKclub
//
//  Created by HuySophanna on 29/6/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import Foundation
import UIKit

class InternalCallController: UIViewController {
    @IBOutlet weak var numberTextField: UITextField!
    
//    var linphoneInstance = LinphoneManager.LinphoneManagerInstance
    var dialPhoneNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.linphoneObj = LinphoneManager()
        
    }
    
    @IBAction func NumberBtnClicked(_ sender: Any) {
        dialPhoneNumber = dialPhoneNumber + ((sender as AnyObject).titleLabel??.text)!
        numberTextField.text = dialPhoneNumber
    }
    
    @IBAction func DelBtnClicked(_ sender: Any) {
        let lastIndex = dialPhoneNumber.index(before: dialPhoneNumber.endIndex)
        dialPhoneNumber = dialPhoneNumber.substring(to: lastIndex)
        numberTextField.text = dialPhoneNumber
    }
    
    @IBAction func CallBtnClicked(_ sender: Any) {
        
        LinphoneManager.makeCall(phoneNumber: dialPhoneNumber)
    }
    
}
