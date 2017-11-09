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
import CallKit
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let manageObjectContext  = appDelegate.persistentContainer.viewContext
var databaseRef = Database.database().reference()
let incomingCallInstance = IncomingCallController()
let firebasedatabaseref =  Database.database().reference()
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
var checkCallKit = ""
var orientationLock = UIInterfaceOrientationMask.all
var iflogOut : Bool = false
var connection : Bool = false
var LinphoneConnectionStatusFlag: Bool = true
var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
var usetoLogin : Bool = false
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
var endCallIncressing = 0
var getsimCall : Bool  = false
var getExtensionSucc : String = ""
var tokenExt_id = ""
var TimeModCheck = Timer()
var TiemeVoip : Timer?
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let callKitManager = CallKitCallInit(uuid: UUID(), handle: "")
    lazy var providerDelegate: ProviderDelegate = ProviderDelegate(callKitManager: self.callKitManager)
    func displayIncomingCall(uuid: UUID, handle: String, completion: ((NSError?) -> Void)?) {
        providerDelegate.reportIncomingCall(uuid: uuid, handle: handle, completion: completion)
    }
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    var window: UIWindow?
    let personService = UserProfileCoreData()
    let gcmMessageIDKey = "gcm.message_id"
    
    
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
        // Override point for customization after application launch.
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
        
        return true
    }
    
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
//        personService.CreatnotificationCoredata(_notification_num: notification_num, _notification_body: body, _notification_title: title)
//        // custom code to handle push while app is in the foreground
//        if let username = userName?.displayName {
//            self.showAlertAppDelegate(title: "Hello "+username, message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
//        } else {
//            self.showAlertAppDelegate(title: "Hello There ", message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
//        }
        
    }
    
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
//        personService.CreatnotificationCoredata(_notification_num: notification_num, _notification_body: body, _notification_title: title)
//        if let username = userName?.displayName {
//            self.showAlertAppDelegate(title: "Hello "+username, message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
//        } else {
//            self.showAlertAppDelegate(title: "Hello There", message: title + ": " + body, buttonTitle:"Okay", window:self.window!)
//        }
        
        
        completionHandler()
    }
    
    // Alert Controller in AppDelegate
    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        alert.dismiss(animated: true, completion: nil)
        window.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    func Dashboard(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "MainDashboard") as!  SWRevealViewController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
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
        if loginBefore || usetoLogin  {
            if !getsimCall {
                incomingCallInstance.EndCallAction()
                
            } else {
                getsimCall = false
            }
        }
       
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
   
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        application.applicationIconBadgeNumber = notification_num
        
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //        endBackgroundTask()
//        if  checkCallKit.isEmpty {
//            switch linphoneInit  {
//            case "logout":
//                print("shutdow voip")
//            case "firstLaunch":
//                break
//            case "login":
//                linphoneInit = "login"
//                break
//            default:
//                linphoneInit = "login"
//                break
//            }
//
//        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        // RestaFrt any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


