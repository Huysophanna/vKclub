//
//  AppDelegate.swift
//  vKclub
//
//  Created by HuySophanna on 30/5/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import UserNotifications
import FirebaseMessaging
import PushKit
import CallKit
import PushKit
import CoreTelephony
import AVFoundation
import CoreLocation



//let callCenter = CXCallObserver()

// Global Variable Start
var isCallBackgroud: Bool = false
var service_names = [String]()
var service_extensions = [String]()
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let manageObjectContext  = appDelegate.persistentContainer.viewContext
var databaseRef = Database.database().reference()
let incomingCallInstance = IncomingCallController()
let userName = Auth.auth().currentUser
var notification_num = 0
let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
let loginBefore = UserDefaults.standard.bool(forKey: "loginBefore")
var changeExtention : Bool = false
var linphoneManager: LinphoneManager? = LinphoneManager()
var userExtensionID = ""
var CHCK_USER_LOCATION = ""
let IN_KIRIROM = "inKirirom"
let OFF_KIRIROM = "offKirirom"
let UNIDENTIFIED = "unidentified"
let INAPP_UNIDENTIFIED = "inApp_unidentified"
var checkwhenappclose  = ""
var iflogoutforfirebase : Bool =  false
var checkCallKit = ""
var orientationLock = UIInterfaceOrientationMask.all
var iflogOut : Bool = false
var connection : Bool = false
var LinphoneConnectionStatusFlag: Bool = true
//var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
var usetoLogin : Bool = false
var ifLogin : Bool = false
var chagne : Bool = false
var deviceId_Inused : Bool = false
var uids = ""
var linphoneInit = "" {
    didSet {
        userExtensionID = linphoneInit
        if linphoneInit == "login"{
            //            linphoneManager?.LinphoneInit()
            linphoneManager?.GetAccountExtension()
        } else if linphoneInit == "logout"{
            
        } else {
            linphoneManager?.LinphoneInit()
        }
        
    }
}
let locationManagers = CLLocationManager()
var endCallIncressing = 0
var getsimCall : Bool  = false
var getExtensionSucc : String = ""
var tokenExt_id = ""
var TimeModCheck = Timer()
var TiemeVoip : Timer?
var decviceCheck : Bool = false



// Global Variable end
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate , URLSessionDelegate {
    //    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, forType type: PKPushType) {
    //
    //    }
    
    let callKitManager = CallKitCallInit(uuid: UUID(), handle: "")
    lazy var providerDelegate: ProviderDelegate = ProviderDelegate(callKitManager: self.callKitManager)
    func displayIncomingCall(uuid: UUID, handle: String, completion: ((NSError?) -> Void)?) {
        providerDelegate.reportIncomingCall(uuid: uuid, handle: handle, completion: completion)
    }
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    let personService = UserProfileCoreData()
    let gcmMessageIDKey = "gcm.message_id"
    // replace DashboardController when call from out side controller 
    var myViewController:DashboardController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Remove border in navigationBar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .blackOpaque
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        // Change navigation title color as default
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        // request permission for local notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
            if granted {
                print("Notification access granted")
            } else {
                print("User reject notification access")
            }
        })
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {data, error in
                    if error != nil{
                        self.showAlertAppDelegate(title: "Error", message: (error?.localizedDescription)! , buttonTitle:"Okay", window:self.window!)                    }
                    
            })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
//        callCenter.callEventHandler = { (call) -> () in
//
//            print(call.callState)
//
//            if call.callState == CTCallStateIncoming {
//
//                isCallBackgroud = true
//            }
//        }
        
        
        // Override point for customization after application launch.
        
        //Firebase Init
        FirebaseApp.configure()
        
        // FB init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // autoLogin
        if launchedBefore  {
            self.LogoutController()
        }
        if loginBefore  {
            //Init linphone sip
            self.Dashboard()
        }
//        let notificationDeviceToekn = InstanceID.instanceID().token()!
//        print(notificationDeviceToekn,"++++test")
        return true
    }
    
    // Recived Notitfication
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        
        if notification.request.content.userInfo["aps"] == nil {
            return
        }
        notification_num += 1
        
        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
        let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        print("Title:\(title) + body:\(body)")
        personService.CreatnotificationCoredata(_notification_num: notification_num, _notification_body: body, _notification_title: title)
        // custom code to handle push while app is in the foreground
        if let username = userName?.displayName {
            self.showAlertAppDelegate(title: "Hello "+username, message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
        } else {
            self.showAlertAppDelegate(title: "Hello There ", message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
        }
        
    }
    // handle the  Notitfication click
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.content.userInfo["aps"] == nil {
            return
        }
        
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        notification_num += 1
        let dict = response.notification.request.content.userInfo["aps"] as! NSDictionary
        print (dict)
        let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        print("Title:\(title) + body:\(body)")
        personService.CreatnotificationCoredata(_notification_num: notification_num, _notification_body: body, _notification_title: title)
        if let username = userName?.displayName {
            self.showAlertAppDelegate(title: "Hello "+username, message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
        } else {
            self.showAlertAppDelegate(title: "Hello There", message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
        }
        
        
        completionHandler()
    }
    
    // Alert Controller in AppDelegate
    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        alert.dismiss(animated: true, completion: nil)
        window.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    //Link to Dashboard
    
    func Dashboard(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "MainDashboard") as!  SWRevealViewController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
        
    }
    //Link to Login
    
    
    func LogoutController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "loginController") as!  LoginController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.configureAudioSession()
        if isCallBackgroud {
            if usetoLogin  {
                if !getsimCall {
                    IncomingCallController.EndCallFlag = true
                    IncomingCallController.InvalidateWaitForStreamRunningInterval()
                    
                } else {
                    getsimCall = false
                }
            }
            isCallBackgroud = false
            return
        }
        
        
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try? session.setActive(true)
            try? session.setPreferredSampleRate(44100.0)
            try? session.setPreferredIOBufferDuration(0.005)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try? session.setMode(AVAudioSessionModeVoiceChat)
        } catch {
            print(error.localizedDescription,"test+++")
        }
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        TimeModCheck.invalidate()
        if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALL_IDLE {
            print("Being idle+++++")
            //invalidate set up call in progress interval
            IncomingCallController.InvalidateSetUpCallInProgressInterval()
            //invalidate wait for stream running interval
            IncomingCallController.InvalidateWaitForStreamRunningInterval()
            LinphoneManager.interuptedCallFlag = false
            IncomingCallController.IncomingCallFlag = false
            IncomingCallController.CallToAction = false
            chagne = false
        } 
//        BackgroundTask.backgroundTaskInstance.startBackgroundTask()
        
    }
    //    func setKeepAliveTimeout(_ timeout: TimeInterval,
    //                             handler keepAliveHandler: (() -> Void)? = nil) -> Bool {
    //        return true
    //    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        myViewController?.TimerInterval()
      
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
    
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Save the local storage when you kill the app
        self.saveContext()
        LinphoneManager.endCall()
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try manageObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


