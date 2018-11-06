//
//  InternetConnectionHelper.swift
//  vKclub
//
//  Created by Pisal on 8/5/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import SystemConfiguration
import SDWebImage
import Firebase

public class InternetConnection {
    
    static var second = 0
    static var countTimer = Timer()
    static var isConnected: Bool = false
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         return isReachable && ! linphoneInit
         */
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
    @objc static func CountSecond(){
        second += 1
        if self.second == 15 {
            second = 0
            self.countTimer.invalidate()
            UIComponentHelper.ProgressDismiss()
            //UIComponentHelper.PresentActivityIndicator(view: UIApplication.topViewController()?.view, option: false)
            UIApplication.topViewController()?.PresentDialogOneActionController(title: "Warning", message: "There is a problem with network connection. Please try again later.", actionTitle: "Okay")
            return
        }
    }
    static func CountTimer() {
        self.countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.CountSecond), userInfo: nil, repeats: true)
        
    }
    func userLogout() {
        
        SDImageCache.shared().clearDisk(onCompletion: nil)
        SDWebImageManager.shared().imageCache?.deleteOldFiles(completionBlock: nil)
        SDImageCache.shared().clearMemory()
        URLCache.shared.removeAllCachedResponses()
        UserDefaults.standard.setIsLoggedIn(value: false)
        try! Auth.auth().signOut()
//        IMAGELOAD = false
        
    }
}
