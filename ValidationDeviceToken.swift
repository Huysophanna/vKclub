//
//  ValidationDeviceToken.swift
//  vKclub
//
//  Created by Machintos-HD on 12/15/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import Foundation
import Firebase

 class ValidationDeviceToken {
    //    static let deviceIdObject = DeviceIdToken()
    func storeuserTokenDevice(uid : String){
        uids = uid
        let deviceId  =  UIDevice.current.identifierForVendor!.uuidString
        databaseRef.child("userDeviceId").child(uid).observe( .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if usetoLogin {
                if value == nil {
                    databaseRef.child("userDeviceId").child(uid).child("device").setValue("")
                    databaseRef.child("userDeviceId").child(uid).child("status").setValue("")
                } else {
                    
                    let getDeviceId = value?["device"] as? String ?? ""
                    let inUsedDevice = value?["status"] as? String ?? ""
                    if getDeviceId.isEmpty && inUsedDevice.isEmpty {
                        databaseRef.child("userDeviceId").child(uid).child("device").setValue(deviceId)
                        databaseRef.child("userDeviceId").child(uid).child("status").setValue("")
                    } else {
                        if usetoLogin {
                            if getDeviceId != deviceId {
                                if inUsedDevice.isEmpty {
                                    if usetoLogin {
                                        self.validationDeviceTokenIsEmpty()
                                    }
                                } else if inUsedDevice == "false" {
                                    databaseRef.child("userDeviceId").child(uid).child("status").setValue("true")
                                } else if inUsedDevice  == "true" {
                                    self.vlidationDeviceInuse()
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                
            }
           
            // ...
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    func validationDeviceTokenIsEmpty() {
        let LocationPermissionAlert = UIAlertController(title: "Warning", message: "Now you are using two device , Do you want to use the lastest device ?", preferredStyle: UIAlertControllerStyle.alert)
        
        LocationPermissionAlert.addAction(UIAlertAction(title: "Cancle", style: .default, handler: { (action: UIAlertAction!) in
            InternetConnection.Logouts()
            InternetConnection.ShutdownPBXServer()
        }))
        LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            let deviceId  =  UIDevice.current.identifierForVendor!.uuidString
            databaseRef.child("userDeviceId").child((Auth.auth().currentUser?.uid)!).child("status").setValue("false")
            databaseRef.child("userDeviceId").child((Auth.auth().currentUser?.uid)!).child("device").setValue(deviceId)
        }))
        UIApplication.topViewController()?.present( LocationPermissionAlert, animated: true, completion: nil)
        
    }
    
    func vlidationDeviceInuse() {
        let LocationPermissionAlert = UIAlertController(title: "Warning", message: "You can not use one account with two devices.You had chooiced the new device", preferredStyle: UIAlertControllerStyle.alert)
        LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            InternetConnection.Logouts()
            InternetConnection.ShutdownPBXServer()
        }))
        UIApplication.topViewController()?.present( LocationPermissionAlert, animated: true, completion: nil)
        
    }
//   func vlidationDeviceInuseAlert(){
//        UIApplication.topViewController()?.PresentAlertController(title: "Warning", message: "You can not use one account with two devices.You had chooiced the new device", actionTitle: "Okay")
//    }
    
    
}


