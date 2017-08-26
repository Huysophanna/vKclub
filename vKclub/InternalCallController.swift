//
//  InternalCallController.swift
//  vKclub
//
//  Created by HuySophanna on 29/6/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class InternalCallController: UIViewController {
    @IBOutlet weak var numberTextField: UITextField!
    var incomingCallInstance: IncomingCallController? = IncomingCallController()
    var dialPhoneNumber: String = ""
    
    @IBOutlet weak var extid: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extid.title = "Your Internal Phone Call number is :"+linephoneinit
        
        
    }
    
    
    @IBAction func NumberBtnClicked(_ sender: Any) {
        if (numberTextField.text == "0") {
            //numberTextField.placeholder =
        }
        dialPhoneNumber = dialPhoneNumber + ((sender as AnyObject).titleLabel??.text)!
        numberTextField.text = dialPhoneNumber
        
    }
    
    @IBAction func DelBtnClicked(_ sender: Any) {
        if (dialPhoneNumber.characters.count > 0) {
            let lastIndex = dialPhoneNumber.index(before: dialPhoneNumber.endIndex)
            dialPhoneNumber = dialPhoneNumber.substring(to: lastIndex)
            numberTextField.text = dialPhoneNumber
        }
        if (dialPhoneNumber.characters.count == 0) {
            //numberTextField.placeholder = "test"
        }
    }
    
    @IBAction func CallBtnClicked(_ sender: Any) {
        if dialPhoneNumber.characters.count != 0 {
            LinphoneManager.makeCall(phoneNumber: dialPhoneNumber)
            IncomingCallController.dialPhoneNumber = dialPhoneNumber
            incomingCallInstance?.callToFlag = true
        }
    }

}
