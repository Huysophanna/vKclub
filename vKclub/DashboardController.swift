//
//  DashboardController.swift
//  vKclub
//
//  Created by Machintos-HD on 6/22/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData
import UserNotifications
import  FirebaseAuth
import AVFoundation

var backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

class DashboardController: UIViewController {
    
    @IBOutlet weak var serviceImg: UIImageView!
    @IBOutlet weak var KiriromScope: UIButton!
    @IBOutlet weak var coverView: UIButton!
    let KIRIROMLAT: Double = 11.316541;
    let KIRIROMLNG: Double = 104.065818;
    let R: Double = 6371; // Radius of the earth in km
    let locationManager = CLLocationManager()
    var lat: Double = 0
    let notificationBtn: UIButton = UIButton (type: UIButtonType.custom)
    var long: Double = 0
    var clickMenu  : Bool  = false
    var notifications = [Notifications]()
    let internalCallControllerInstance = InternalCallController()
//    var linphoneConnectionStatusFlag: Bool = true {
//        didSet {
//     //            DashboardController.LinphoneConnectionStatusFlag = linphoneConnectionStatusFlag
////            PrepareLocalNotificationForConnectionStatus(isConnected: linphoneConnectionStatusFlag)
//
//            //change extension connection status in Internal Phone Call view
////            internalCallControllerInstance.ChangeExtensionActiveStatus(color: DashboardController.LinphoneConnectionStatusFlag == true ? UIColor.green : UIColor.red)
//        }
//    }
    
    
    let setting = UserDefaults.standard.integer(forKey: "setting")
    override func viewDidLoad() {
        super.viewDidLoad()
        linphoneInit  = "login"
        notificationBtn.tag = 6
        notificationBtn.setImage(UIImage(named: "Notification"), for: UIControlState.normal)
        notificationBtn.addTarget(self, action: #selector(self.BtnTag), for: .touchUpInside)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let barButton = UIBarButtonItem(customView: notificationBtn)
        let width = barButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        width?.isActive = true
        let height = barButton.customView?.heightAnchor.constraint(equalToConstant: 25)
        height?.isActive = true
        self.navigationItem.rightBarButtonItem = barButton
        if iflogOut {
            iflogOut = false
            checkwhenappclose = "Login"
            InternetConnection.ShutdownPBXServer()
        }
       
        CheckWhenUserChangePassword ()       // login for registerForRemoteNotifications
        UserDefaults.standard.set(true, forKey: "loginBefore")
        if setting == 0 || setting == 1 {
            UIApplication.shared.registerForRemoteNotifications()
        }else{
             UIApplication.shared.unregisterForRemoteNotifications()
        }
       
        //init background task for incoming call
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        loadData()
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        TimeModCheck  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.isKirirom), userInfo: nil, repeats: true)
        //recall backgroundTask since making call interrupt and end our audio backgroundTask
        BackgroundTask.backgroundTaskInstance.startBackgroundTask()
        KiriromScope.setTitle("Identifying", for: .normal)
        coverView.isHidden = true
        coverView.isUserInteractionEnabled = false
        navigationController?.hidesBarsOnSwipe = false
        let session = AVAudioSession.sharedInstance()
        
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    
                    do {
                        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                        try session.setActive(true)
                    }
                    catch {
                        print("Couldn't set Audio session category")
                    }
                } else{
                    print("not granted")
                }
            })
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    //*** This is required to fix navigation bar forever disappear on fast backswipe bug.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

   

    
    @IBAction func BtnTag(_sender:Any){
        
        CheckWhenUserChangePassword ()
        let btntag : Int = (_sender as AnyObject).tag
        switch  btntag {
        case 0:
            performSegue(withIdentifier: "PushService", sender: self)
            break
        case 1:
            performSegue(withIdentifier: "PushMap", sender: self)
            break
        case 2:
             performSegue(withIdentifier: "PushAboutUs", sender: nil)
            break
        case 3:
             PresentAlertController(title: "Coming Soon!", message: "Introducing vKirirom Membership Card with vPoints, will be available soon.", actionTitle: "Okay")
            break
        case 6:
            //linphone_core_set_network_reachable(LinphoneManager.lcOpaquePointerData, 1)
            self.navigationItem.rightBarButtonItem?.removeBadge()
            performSegue(withIdentifier: "GotoNotification", sender: self)
            break
            
        default:
            switch CHCK_USER_LOCATION {
            case IN_KIRIROM:
                if btntag == 4 {
                    CheckWhenUserChangePassword ()
                    switch getExtensionSucc {
                        case "Extension":
                            if linphoneInit == "login"{
                                 PresentAlertController(title: "Please wait", message: "We are trying to generate and activate   your caller ID. Please try again in seconds.", actionTitle: "Okay")
                            } else {
                               performSegue(withIdentifier: "PushInternalCall", sender: self)
                            }
                            break
                        
                        case "400":
                            PresentAlertController(title: "Something went wrong", message: "Sorry, our internal phone call services are currently not available right now. Please try again next time.", actionTitle: "Okay")
                      
                            break
                        case "getExtensionSucc":
                            PresentAlertController(title: "Something went wrong", message: "You are not connected to our server. Please ensure that you are connected to our network and try again later.", actionTitle: "Okay")
                    
                            break
                        
                        default:
                            PresentAlertController(title: "Please wait", message: "We are trying to generate and activate   your caller ID. Please try again in seconds.", actionTitle: "Okay")
                            break
                    }
                
                } else {
                  PresentAlertController(title: "In-Kirirom Mode", message: "Welcome to vKirirom. Experience full features of vKclub with In-Kirirom mode including Emergency SOS & Free internal phone call", actionTitle: "Okay")
                }
                break
            case OFF_KIRIROM:
                PresentAlertController(title: "Off-Kirirom Mode", message: "Emergency SOS & Free internal   phone call features are not accessible for Off-Kirirom users.", actionTitle: "Okay")
                break
            case UNIDENTIFIED:
                UIComponentHelper.LocationPermission(INAPP_UNIDENTIFIEDSetting: false)
                
                break
            case INAPP_UNIDENTIFIED:
                UIComponentHelper.LocationPermission(INAPP_UNIDENTIFIEDSetting: true)
                break
            default:
                PresentAlertController(title: "Off-Kirirom Mode", message: "Emergency SOS & Free internal   phone call features are not accessible for Off-Kirirom users.", actionTitle: "Okay")

                break
                
            }
            
        }
    
    }
    //animate button on click
    func AnimateBtn(senderBtn: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.serviceImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.serviceImg.tintColor = UIColor.gray
        }, completion: { animationFinished in
            UIView.animate(withDuration: 0.1, animations: {
                self.serviceImg.transform = CGAffineTransform.identity
                self.serviceImg.tintColor = UIColor.white
            })
            
        })
    }
    
    //Func for show the Slidemenu
    func Slidemenu() {
        CheckWhenUserChangePassword ()
        if revealViewController() != nil {
            self.revealViewController().revealToggle(animated: true)
            
            if  clickMenu {
                coverView.isHidden = true
                coverView.isUserInteractionEnabled = false
                clickMenu = false
                
            } else {
                coverView.isHidden = false
                coverView.isUserInteractionEnabled = true
                clickMenu = true
            }
           revealViewController().rearViewRevealWidth = (view.bounds.width * 80 ) / 100
            
            
            
        }
    }
    
    func PrepareLocalNotificationForConnectionStatus(isConnected: Bool) {
        var title: String
        var body: String
        if isConnected {
            title = "PhoneCall Registered"
            body = "You are connected. Available to recieve and make call."
        } else {
            title = "PhoneCall Registration Failed"
            body = "You are not connected. Please connect to our wifi network to recieve and make call."
        }
        UIComponentHelper.scheduleNotification(_title: title, _body: body, _inSeconds: 0.1)
    }
    
    
    
    
    func isKirirom() {
        CHCK_USER_LOCATION = CheckUserLocation()
        switch CHCK_USER_LOCATION {
            
        case IN_KIRIROM:
            KiriromScope.setTitle("In-Kirirom Mode", for: .normal)
            let mainGreen = UIColor(hexString: "#008040", alpha: 1)
            KiriromScope.setTitleColor(mainGreen, for: .normal)
        break
        case OFF_KIRIROM:
            KiriromScope.setTitle("Off-Kirirom Mode", for: .normal)
            let mainGreen = UIColor(hexString: "#008040", alpha: 1)
            KiriromScope.setTitleColor(mainGreen, for: .normal)
        break
        case INAPP_UNIDENTIFIED:
            KiriromScope.setTitle("Unidentified Mode", for: .normal)
            KiriromScope.setTitleColor(UIColor.yellow, for: .normal)
        break
        default:
            KiriromScope.setTitle("Unidentified Mode", for: .normal)
            KiriromScope.setTitleColor(UIColor.red, for: .normal)
        }
        if notification_num > 0 {
           self.navigationItem.rightBarButtonItem?.addBadge(number: notification_num, withOffset: CGPoint(x: -5, y: -5), andColor: .red, andFilled: true)
        } else{
            self.navigationItem.rightBarButtonItem?.removeBadge()
        }
        
        
//        if CheckUserLocation() == IN_KIRIROM {
//            print(LinphoneManager.CheckLinphoneConnectionStatus(),  "==STATUS===")
//            if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALL_IDLE {
//                print("Being idle+++++")
//                //invalidate set up call in progress interval
//                IncomingCallController.InvalidateSetUpCallInProgressInterval()
//
//                //invalidate wait for stream running interval
//                IncomingCallController.InvalidateWaitForStreamRunningInterval()
//                LinphoneManager.interuptedCallFlag = false
//                IncomingCallController.IncomingCallFlag = false
//                IncomingCallController.CallToAction = false
//            }
//
//            //Push localNotification to show user about linphone connection status
//            if LinphoneManager.CheckLinphoneConnectionStatus() {
//                if iflogOut {
//                    return
//                }
//                if DashboardController.LinphoneConnectionStatusFlag == false {
//                    linphoneConnectionStatusFlag = true
//
//                }
//            } else {
//                if DashboardController.LinphoneConnectionStatusFlag {
//                    linphoneConnectionStatusFlag = false
//                }
//            }
//
//            LinphoneManager.register(proxyConfig!)
//            print("registering --++")
//        }
        
    }
    
    @IBAction func MenuClick(_ sender: Any) {
        Slidemenu()
    }
    
    

    @IBAction func SwipeMenuRight(_ sender: UISwipeGestureRecognizer) {
       Slidemenu()
    }
    
    @IBAction func SwipeMenuLeft(_ sender: UISwipeGestureRecognizer) {
        if clickMenu {
            Slidemenu()
        }
    }
    
    
    func CheckUserLocation() -> String {
        self.locationManager.requestAlwaysAuthorization()// request user location
        self.locationManager.requestWhenInUseAuthorization()
        
        //when user allow location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate//Check delgate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters//Check the desiredAccurac
            locationManager.startUpdatingLocation()
            // if location not null
            if (locationManager.location?.coordinate.longitude != nil) {
                let currentlocation_lat = Double((locationManager.location?.coordinate.latitude)!)
                let currentlocation_long = Double((locationManager.location?.coordinate.longitude)!)
                let kiriromscope :Double = Double(distanceCal(lat:currentlocation_lat ,long:currentlocation_long))
                if (kiriromscope < 17) {
                    lat = currentlocation_lat
                    long = currentlocation_long
                    
                    return IN_KIRIROM
                } else {
                    return OFF_KIRIROM
                }
                
            } else {
                //unable to get location when you close the vKclub location service in application setting
                return INAPP_UNIDENTIFIED
            }
            
            
        } else {
            //unable to get location when you close all the app location service
              return UNIDENTIFIED
        }
        
    }
    
   
    
    
    
    //user scope
    func distanceCal(lat:Double,long:Double) -> Double {
        let dLat : Double = (KIRIROMLAT-lat)*(Double.pi/180)
        let dLon : Double = (KIRIROMLNG-long)*(Double.pi/180)
        let a : Double = sin(dLat/2) * sin(dLat/2) + cos(lat*(Double.pi/180))*cos(KIRIROMLAT*(Double.pi/180)) * sin(dLon/2) * sin(dLon/2);
        let c :Double = 2 * atan2(sqrt(a), sqrt(1-a));
        let d :Double = R * c; // Distance in km
        return d
    }
    
    
    @IBAction func SwipeMenu(_ sender: UISwipeGestureRecognizer) {
        Slidemenu()
    }

    
    
    func LocationPermission(INAPP_UNIDENTIFIEDSetting : Bool){
        let LocationPermissionAlert = UIAlertController(title: "Location Permission Denied.", message: "Turn on Location Service to Determine your current location for App Mode", preferredStyle: UIAlertControllerStyle.alert)
        
        LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            if INAPP_UNIDENTIFIEDSetting {
               
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
            } else{
                UIApplication.shared.open(URL(string:"App-Prefs:root=Privacy")!, options: [:], completionHandler: nil)
             }
            
        }))
         LocationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present( LocationPermissionAlert, animated: true, completion: nil)
    }
    func loadData(){
        let notificationRequest:NSFetchRequest<Notifications> = Notifications.fetchRequest()
        
        do {
            notifications = try manageObjectContext.fetch(notificationRequest)
            for i in notifications {
                notification_num = Int(i.notification_num)
            }
            
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    func CheckWhenUserChangePassword (){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            user?.reload(completion: { (error) in
                if error?.localizedDescription ==  "The user's credential is no longer valid. The user must sign in again." {
                    let LocationPermissionAlert = UIAlertController(title: "Warning", message: "Your account had changed password,inorder to process the vKclub you need to login again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                        InternetConnection.Logouts()}))
                    
                    self.present( LocationPermissionAlert, animated: true, completion: nil)
                }
            })
        }

    }

}



