//
//  ViewController.swift
//  Onboarding
//
//  Created by Training on 20/11/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit
import paper_onboarding


class ViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var onboardingView: OnboardingView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        onboardingView.dataSource = self
        onboardingView.delegate = self
        skipBtn.isHidden = true
    }
    func onboardingItemsCount() -> Int {
        return 6
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        var titleFont : UIFont
        var descirptionFont : UIFont
        var modelName: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            switch identifier {
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            default:                                        return identifier
            }
        }
        
        let greenBackgroundColor = UIColor(hexString: "#008040", alpha: 1)
        if modelName == "iPhone 5" || modelName == "iPhone 5c" || modelName == "iPhone 5s" {
            descirptionFont = UIFont(name: "AvenirNext-Regular", size: 15)!
            titleFont = UIFont(name: "AvenirNext-Bold", size: 20)!
        } else {
            descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
            titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        }
        
        
        return [ ("welcome-intro", "Welcome to vKclub", "Maximize your vKirirom Pine Resort \nexperience.Explore, Discover and Meet new people with vKclub", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                 
                 ("map-intro", "Map", "Digitalized Map designed to\n help users to get in touch with\n our vKirirom Pine Resort\n Facilities and Services", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                 
                 ("voip-intro", "Internal Phone Call", "Free Call and No Restrictions", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont),
                 
                 ("sos-intro", "Emergency SOS", "Emergency SOS button guarantees \nusers safety. Help during emergency \nor in dangerous situation", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont),
                 ("mode-intro", "IN-Kirirom / OFF-Kirirom Mode", "Experience all functions of the app in IN-Kirirom mode and also in off-Kirirom \nmode, except SOS and Internal Phone Call", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                 ("ready-intro", "You are all set to Enjoy vKclub", "", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
        
    }
    
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        item.imageView?.frame =  CGRect(x: 0, y: 0, width: 50, height: 50)
        
    }
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 0 {
            skipBtn.isHidden = true
            
        }
        if index == 1 {
            skipBtn.isHidden = false
            self.getStartedButton.isHidden = true
            self.getStartedButton.alpha = 0
            
            
        }
        if index == 2 {
            skipBtn.isHidden = false
            
            self.getStartedButton.isHidden = true
            self.getStartedButton.alpha = 0
            
            
        }
        if index == 3 {
            skipBtn.isHidden = false
            self.getStartedButton.isHidden = true
            self.getStartedButton.alpha = 0
            
            
        }
        if index == 4 {
            skipBtn.isHidden = false
            self.getStartedButton.alpha = 0
            self.getStartedButton.isHidden = true
            
            
        }
        
        
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 5 {
            skipBtn.isHidden = true
            self.getStartedButton.alpha = 1
            self.getStartedButton.isHidden = false
            
        }
    }
    
    
    
    @IBAction func gotStarted(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "onboardingComplete")
        
        userDefaults.synchronize()
        
    }
    
    @IBAction func SkipBtn(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "launchedBefore")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


