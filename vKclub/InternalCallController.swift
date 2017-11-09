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

class InternalCallController: UIViewController{
    @IBOutlet weak var numberTextField: UITextField!
    static let extensionBtn = UIButton(type: .system)
    var incomingCallInstance: IncomingCallController? = IncomingCallController()
    var dialPhoneNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usetoLogin = true
        getTopViewController().dismiss(animated: false, completion: nil)
        
        //make extension button with connection status
        MakeExtensionButton(color: LinphoneConnectionStatusFlag == true ? UIColor.red : UIColor.green)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func ChangeExtensionActiveStatus(color: UIColor) {
        InternalCallController.extensionBtn.tintColor = color
    }
    
    func MakeExtensionButton(color: UIColor) {
        InternalCallController.extensionBtn.setImage(#imageLiteral(resourceName: "active-dot"), for: .normal)
        InternalCallController.extensionBtn.imageView?.contentMode = .scaleAspectFit
        
        InternalCallController.extensionBtn.tintColor = color
        InternalCallController.extensionBtn.setTitleColor(UIColor.white, for: .normal)
        
        InternalCallController.extensionBtn.frame = CGRect(x: 0, y: 0, width: 70, height: 10)
        InternalCallController.extensionBtn.setTitle(userExtensionID, for: .normal)
        InternalCallController.extensionBtn.contentHorizontalAlignment = .center
        
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: InternalCallController.extensionBtn)
    }
    
    
    @IBAction func NumberBtnClicked(_ sender: Any) {
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
        if InternetConnection.AudioPermissiom(){
            if dialPhoneNumber.characters.count != 0 {
                if LinphoneManager.CheckLinphoneConnectionStatus() {
                    IncomingCallController.dialPhoneNumber = dialPhoneNumber
                    //prevent calling to their own number
                    if userExtensionID == IncomingCallController.dialPhoneNumber {
                        PresentAlertController(title: "Something went wrong", message: "You are about to call to your own ID. Please choose another ID and try again.", actionTitle: "Got it")
                        return
                    }
                    
                    incomingCallInstance?.callToFlag = true
                    LinphoneManager.makeCall(phoneNumber: dialPhoneNumber)
                    
                    
                } else {
                    //LinphoneCallError occurred
                    PresentAlertController(title: "Something went wrong", message: "You are not connected to our server. Please ensure that you are connected to our network and try again later.", actionTitle: "Okay")
                }
            }
            
        } else {
            let LocationPermissionAlert = UIAlertController(title: "Audio Permission Denied.", message: "Turn on Audio Service to process the internal phone call", preferredStyle: UIAlertControllerStyle.alert)
            
            LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
            }))
            LocationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present( LocationPermissionAlert, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
}

