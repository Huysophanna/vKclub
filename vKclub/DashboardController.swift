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

var backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

class DashboardController: UIViewController {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var KiriromScope: UIButton!
    
    let IN_KIRIROM = "inKirirom"
    let OFF_KIRIROM = "offKirirom"
    let UNIDENTIFIED = "unidentified"
    let INAPP_UNIDENTIFIED = "inApp_unidentified"
    let KIRIROMLAT : Double = 11.316541;
    let KIRIROMLNG : Double = 104.065818;
    let R : Double = 6371; // Radius of the earth in km
    let locationManager = CLLocationManager()
    var lat: Double = 0
    var long:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init background task for incoming call
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.isKirirom), userInfo: nil, repeats: true)
        Slidemenu()
        
        KiriromScope.setTitle("Identifying", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func ServiceBtn(_ sender: Any) {
        performSegue(withIdentifier: "PushService", sender: self)
    }
    
    @IBAction func InternalCallBtn(_ sender: Any) {
//        LinphoneManager.getLinphoneCallIdentify()
        LinphoneManager.register(proxyConfig!)
        performSegue(withIdentifier: "PushInternalCall", sender: self)
    }
   
    @IBAction func BtnMap(_ sender: Any) {
        performSegue(withIdentifier: "PushMap", sender: self)
    }

    @IBAction func AboutUsBtn(_ sender: Any) {
        performSegue(withIdentifier: "PushAboutUs", sender: nil)
        
        
    }
    @IBAction func MembershipBtn(_ sender: Any) {
        PresentAlertController(title: "Coming Soon!", message: "Introducing vKirirom Membership Card with vPoints, will be available soon.", actionTitle: "Okay")
    }
    
    @IBAction func ModeBtn(_ sender: Any) {
        switch CheckUserLocation() {
        case IN_KIRIROM:
            PresentAlertController(title: "In-Kirirom Mode", message: "Welcome to vKirirom. Experience full features of vKclub with In-Kirirom mode including Emergency SOS & Free internal phone call", actionTitle: "Okay")
        break
        case OFF_KIRIROM:
            PresentAlertController(title: "Off-Kirirom Mode", message: "Emergency SOS & Free internal phone call features are not accessible for Off-Kirirom users.", actionTitle: "Okay")
        break
        case UNIDENTIFIED:
            LocationPermission(INAPP_UNIDENTIFIEDSetting: false)
            
        break
        case INAPP_UNIDENTIFIED:
            LocationPermission(INAPP_UNIDENTIFIEDSetting: true)
        break
        default: break
        }

    }
    
// func for show the Slidemenu
    func Slidemenu() {
        if revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rearViewRevealWidth = (view.bounds.width * 80) / 100
            
            print(view.bounds.width, "======width====")
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func isKirirom() {
        let Check : String =  CheckUserLocation()
        if Check == IN_KIRIROM {
            KiriromScope.setTitle("In-Kirirom Mode", for: .normal)
            let mainGreen = UIColor(hexString: "#008040", alpha: 1)
            KiriromScope.setTitleColor(mainGreen, for: .normal)
            
        } else if Check == OFF_KIRIROM {
            KiriromScope.setTitle("Off-Kirirom Mode", for: .normal)
            let mainGreen = UIColor(hexString: "#008040", alpha: 1)
            KiriromScope.setTitleColor(mainGreen, for: .normal)
            
        } else if Check == INAPP_UNIDENTIFIED {
            KiriromScope.setTitle("Unidentified Mode", for: .normal)
            KiriromScope.setTitleColor(UIColor.yellow, for: .normal)
            
        } else {
            KiriromScope.setTitle("Unidentified Mode", for: .normal)
            KiriromScope.setTitleColor(UIColor.red, for: .normal)
        }
        
        //Set linphoneCall identity
        LinphoneManager.register(proxyConfig!)
        
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
            if (locationManager.location?.coordinate.longitude != nil){
                let currentlocation_lat = Double((locationManager.location?.coordinate.latitude)!)
                let currentlocation_long = Double((locationManager.location?.coordinate.longitude)!)
                let kiriromscope :Double = Double(distanceCal(lat:currentlocation_lat ,long:currentlocation_long))
                if(kiriromscope < 17){
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
    func distanceCal(lat:Double,long:Double) -> Double   {
        let dLat : Double = (KIRIROMLAT-lat)*(Double.pi/180)
        let dLon : Double = (KIRIROMLNG-long)*(Double.pi/180)
        let a : Double = sin(dLat/2) * sin(dLat/2) + cos(lat*(Double.pi/180))*cos(KIRIROMLAT*(Double.pi/180)) * sin(dLon/2) * sin(dLon/2);
        let c :Double = 2 * atan2(sqrt(a), sqrt(1-a));
        let d :Double = R * c; // Distance in km
        return d
    }
    
    @IBAction func NoticationBtn(_ sender: Any) {
        performSegue(withIdentifier: "GotoNotification", sender: self)
    }
    func LocationPermission(INAPP_UNIDENTIFIEDSetting : Bool){
        let LocationPermissionAlert = UIAlertController(title: "Location disabled for vKclub App", message: "Please enable Location by Clicking Okay", preferredStyle: UIAlertControllerStyle.alert)
        
        LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            if INAPP_UNIDENTIFIEDSetting {
               
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
            } else{
                UIApplication.shared.open(URL(string:"App-Prefs:root=Privacy")!, options: [:], completionHandler: nil)

             }
            
        }))
         LocationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (action: UIAlertAction!) in
            
        }))
        self.present( LocationPermissionAlert, animated: true, completion: nil)
    }
}
