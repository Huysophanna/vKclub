import UIKit
import SystemConfiguration
import Firebase
import AVFoundation

// Internet Vaidation Helper...
public class InternetConnection {
    static var second = 0
    static var countTimer = Timer()
    static var isConnected: Bool = false
    static let personService = UserProfileCoreData()
    
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
         return isReachable && !needsConnection
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
            UIComponentHelper.PresentActivityIndicator(view: UIApplication.topViewController()?.view, option: false)
            UIApplication.topViewController()?.PresentAlertController(title: "Warning", message: "There is a problem with network connection. Please try again later.", actionTitle: "Okay")
            return
        }
    }
    static func CountTimer() {
        self.countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.CountSecond), userInfo: nil, repeats: true)
    
    }
    static func DeleteExtension() {
        personService.deleteAllData(entity: "Extension")
    }
    static func Logouts(){
        getExtensionSucc = "Logout"
        UserDefaults.standard.set(false, forKey: "loginBefore")
        UIApplication.shared.unregisterForRemoteNotifications()
        notification_num = 0
        personService.deleteAllData(entity: "SipCallData")
        personService.deleteAllData(entity: "UserProfile")
        personService.deleteAllData(entity: "Notifications")
        personService.deleteAllData(entity: "Extension")
        try! Auth.auth().signOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "loginController") as!  LoginController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
    }
    static func ShutdownPBXServer(){
        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            TimeModCheck.invalidate()
            if LinphoneManager.CheckLinphoneConnectionStatus() {
                LinphoneManager.shutdown()
                if checkwhenappclose == "Logout" {
                    linphoneInit = "logout"
                }
                
            } else {
                // user to check if user logout when no connection to PBX server.
                //in case connection is false, then set these flags to false
                UserDefaults.standard.set(false, forKey: "userAuthInfoAddedFlag")
                LinphoneManager.shutDownFlag = false
                if checkwhenappclose == "Logout" {
                    iflogOut = true
                    linphoneInit = "logout"
                }
            }
        }
       
        
        
    }
    static  func AudioPermissiom() -> Bool {
    var audioPermission : Bool
    switch AVAudioSession.sharedInstance().recordPermission() {
         case AVAudioSessionRecordPermission.granted:
            audioPermission  = true
            break
         default:
            audioPermission  = false
     
            break
    }
      return  audioPermission
    }
    
    

}
