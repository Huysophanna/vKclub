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
        isKirirom()
        let time = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.isKirirom), userInfo: nil, repeats: true)
        Slidemenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func ServiceBtn(_ sender: Any) {
        performSegue(withIdentifier: "PushService", sender: self)
    }
    
    @IBAction func InternalCallBtn(_ sender: Any) {
        performSegue(withIdentifier: "PushInternalCall", sender: self)
    }
   
    @IBAction func BtnMap(_ sender: Any) {
        performSegue(withIdentifier: "PushMap", sender: self)
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
            PresentAlertController(title: "Unidentified Mode", message: "Location service failed. Turn on Location Service to determine your current location for App Mode: \n Setting > Privacy > Location Services > ON", actionTitle: "Okay")
        break
        case INAPP_UNIDENTIFIED:
            PresentAlertController(title: "Unidentified Mode", message: "Location service failed. Turn on Location Service to determine your current location for App Mode: \n Setting > Privacy > Location Services > vKclub > Always", actionTitle: "Okay")
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
        if Check == "inKirirom" {
            KiriromScope.setTitle("In-Kirirom Mode", for: .normal)
            let mainGreen = UIColor(hexString: "#008040", alpha: 1)
            KiriromScope.setTitleColor(mainGreen, for: .normal)
            
        } else if Check == "offKirirom" {
            KiriromScope.setTitle("Off-Kirirom Mode", for: .normal)
            let mainGreen = UIColor(hexString: "#008040", alpha: 1)
            KiriromScope.setTitleColor(mainGreen, for: .normal)
            
        } else if Check == "identifying" {
            KiriromScope.setTitle("Identifying...", for: .normal)
            KiriromScope.setTitleColor(UIColor.yellow, for: .normal)
            
        } else {
            KiriromScope.setTitle("Unidentified Mode", for: .normal)
            KiriromScope.setTitleColor(UIColor.red, for: .normal)
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
}
