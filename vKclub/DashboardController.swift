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

var backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

class DashboardController: UIViewController {
    @IBOutlet weak var serviceImg: UIImageView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var KiriromScope: UIButton!
    @IBOutlet weak var notificationBtn: UIBarButtonItem!
    let IN_KIRIROM = "inKirirom"
    let OFF_KIRIROM = "offKirirom"
    let UNIDENTIFIED = "unidentified"
    let INAPP_UNIDENTIFIED = "inApp_unidentified"
    let KIRIROMLAT: Double = 11.316541;
    let KIRIROMLNG: Double = 104.065818;
    let R: Double = 6371; // Radius of the earth in km
    let locationManager = CLLocationManager()
    var lat: Double = 0
    var long: Double = 0
    var notifications = [Notifications]()
    var linphoneConnectionStatusFlag: Bool = true {
        didSet {
            PrepareLocalNotificationForConnectionStatus(isConnected: linphoneConnectionStatusFlag)
        }
    }
    
    override func viewDidLoad() {
        
        UserDefaults.standard.set(true, forKey: "loginBefore")
        
        //init background task for incoming call
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        loadData()
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.isKirirom), userInfo: nil, repeats: true)
        
        //recall backgroundTask since making call interrupt and end our audio backgroundTask
        BackgroundTask.backgroundTaskInstance.startBackgroundTask()

        Slidemenu()
        KiriromScope.setTitle("Identifying", for: .normal)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func BtnTag(_sender:Any){
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
            self.notificationBtn.removeBadge()
            notification_num = 0
            performSegue(withIdentifier: "GotoNotification", sender: self)

            break
            
        default:
            switch CheckUserLocation() {
            case IN_KIRIROM:
                if btntag == 4{
                    LinphoneManager.register(proxyConfig!)
                    performSegue(withIdentifier: "PushInternalCall", sender: self)

                }else{
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
                print("not thing")
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
        if revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rearViewRevealWidth = (view.bounds.width * 80) / 100
            
            print(view.bounds.width, "======width====")
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
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
        switch CheckUserLocation() {
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
            self.notificationBtn.addBadge(number: notification_num, withOffset: CGPoint(x: 10, y: 10), andColor: .red, andFilled: true)
        } else{
            self.notificationBtn.removeBadge()
        }
        
        if CheckUserLocation() == IN_KIRIROM {
            //Set linphoneCall identity
            LinphoneManager.register(proxyConfig!)
            
            //Push localNotification to show user about linphone connection status
            if LinphoneManager.CheckLinphoneConnectionStatus() {
                if !linphoneConnectionStatusFlag {
                    linphoneConnectionStatusFlag = true
                }
            } else {
                if linphoneConnectionStatusFlag {
                    linphoneConnectionStatusFlag = false
                }
            }
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
            print (locationManager.startUpdatingLocation())
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

    
    
    func LocationPermission(INAPP_UNIDENTIFIEDSetting : Bool){
        let LocationPermissionAlert = UIAlertController(title: "Location Permission Denied.", message: "Turn on Location Service to Determine your current location for App Mode", preferredStyle: UIAlertControllerStyle.alert)
        
        LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            if INAPP_UNIDENTIFIEDSetting {
               
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
            } else{
                UIApplication.shared.open(URL(string:"App-Prefs:root=Privacy")!, options: [:], completionHandler: nil)
             }
            
        }))
         LocationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        self.present( LocationPermissionAlert, animated: true, completion: nil)
    }
    func loadData(){
        let notificationRequest:NSFetchRequest<Notifications> = Notifications.fetchRequest()
        
        do {
            notifications = try manageObjectContext.fetch(notificationRequest)
            for i in notifications{
                notification_num = Int(i.notification_num)
            }
            
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }

}
