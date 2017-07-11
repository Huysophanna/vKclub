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
    let KIRIROMLAT : Double = 11.316541;
    let KIRIROMLNG : Double = 104.065818;
    let R : Double = 6371; // Radius of the earth in km
    let locationManager = CLLocationManager()
    var lat: Double = 0
    var long:Double = 0
    
   
   

    @IBOutlet weak var KiriromScope: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let time = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.isKirirom), userInfo: nil, repeats: true)
        Slidemenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func ServiceBtn(_ sender: Any) {
        performSegue(withIdentifier: "PushInternalCall", sender: self)
    }
    
   
    
   @IBAction func BtnMap(_ sender: Any) {
        performSegue(withIdentifier: "PushMap", sender: self)
    }
  

    
// func for show the Slidemenu
    func Slidemenu(){
        if revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rearViewRevealWidth = 350
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
     func isKirirom(){
        let Check : String =  CheckuserLocstion()
        if ( Check == "inKirirom"){
            KiriromScope.setTitle("In-Kirirom", for: .normal)
            
        }else if (Check == "offKirirom"){
            KiriromScope.setTitle("off-Kirirom", for: .normal)
            
        }else if( Check == "identifying"){
            KiriromScope.setTitle("identifying", for: .normal)

            
        }else{
            
            KiriromScope.setTitle("undefined", for: .normal)
        }
        
    }
    func CheckuserLocstion() -> String{
        
        
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
                   
                   
                    
                    return "inKirirom"
                    
                }else{
                    
                    return "offKirirom"
                        
                }
            }else{
                
                //undefine location when you close the vKclub location service
                return "identifying"
            }
            
            
        }else{
            //undefine location when you close all the app location service
              return "undefined"
           }
        
    }
    //user scope
    func distanceCal(lat:Double,long:Double) -> Double   {
        let dLat : Double = (KIRIROMLAT-lat)*(Double.pi/180)
        let dLon : Double = (KIRIROMLNG-long)*(Double.pi/180)
        let a : Double = sin(dLat/2) * sin(dLat/2) + cos(lat*(Double.pi/180))*cos(KIRIROMLAT*(Double.pi/180)) * sin(dLon/2) * sin(dLon/2);
        let c :Double = 2 * atan2(sqrt(a), sqrt(1-a));
        let d:Double = R * c; // Distance in km
               
        return d
    }
    @IBAction func NoticationBtn(_ sender: Any) {
        performSegue(withIdentifier: "GotoNotification", sender: self)
    }
    
    

}
