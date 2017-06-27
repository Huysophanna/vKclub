//
//  DashboardController.swift
//  vKclub
//
//  Created by Machintos-HD on 6/22/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import UIKit
import GoogleMaps

class DashboardController: UIViewController {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    let KIRIROMLAT : Double = 11.316541;
    let KIRIROMLNG : Double = 104.065818;
    let R : Double = 6371; // Radius of the earth in km
    let locationManager = CLLocationManager()

    @IBOutlet weak var KiriromScope: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.CheckuserLocstion), userInfo: nil, repeats: true)
        Slidemenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func ServiceBtn(_ sender: Any) {
        performSegue(withIdentifier: "PushService", sender: self)
    }
    
    @IBAction func MapBtn(_ sender: Any) {
        performSegue(withIdentifier: "PushMap", sender: self)
    }
  
//    func CheckLocationMode()  {
//
//        CheckLocation.layer.cornerRadius = 10.0
//        CheckLocation.clipsToBounds = true
//        
//    }

    
// func for show the Slidemenu
    func Slidemenu(){
        if revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func CheckuserLocstion(){
        
        
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
                    KiriromScope.setTitle("In-Kirirom", for: .normal)
                }
                else{
                    KiriromScope.setTitle("Off-Kirirom", for: .normal)
                    
                }
            }
            else{
                
                //undefine location
                KiriromScope.setTitle("undefined", for: .normal)
            }
            
        }
        else{
            KiriromScope.setTitle("undefined", for: .normal)
        }
    }
    
    
    
    //user scope
    func distanceCal(lat:Double,long:Double) -> Double   {
        var dLat : Double = (KIRIROMLAT-lat)*(Double.pi/180)
        var dLon : Double = (KIRIROMLNG-long)*(Double.pi/180)
        var a : Double = sin(dLat/2) * sin(dLat/2) + cos(lat*(Double.pi/180))*cos(KIRIROMLAT*(Double.pi/180)) * sin(dLon/2) * sin(dLon/2);
        var c :Double = 2 * atan2(sqrt(a), sqrt(1-a));
        var d:Double = R * c; // Distance in km
        print (d)
        
        return d
        
    }
    

}
