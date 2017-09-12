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
        let greenBackgroundColor = UIColor(hexString: "#008040", alpha: 1)
       
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return [ ("welcome-intro", "Welcome to vKclub", "Maximize your vKirirom Pine Resort experience.Explore,\n Discover and Meet new people with vKclub", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                 ("map-intro", "Map", "Digitalized Map designed to\n help users to get in touch with\n our vKirirom Pine Resort\n Facilities and Services", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                 ("voip-intro", "Internal Phone Call", "Free Call and No Restrictions", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                 ("sos-intro", "Emergency SOS", "Emergency SOS button guarantees \nusers safety.Help during emergency or \n  in dangerous situation", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont),
                 ("mode-intro", "On-site / Off-site Mode", "Experience all functions of the app in on-site \nmode and also in off-site mode, except \nSOS and Internal Phone Call", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                 ("ready-intro", "You are all set Enjoy vKclub", "", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
        
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
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }
        if index == 2 {
            skipBtn.isHidden = false
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }
        if index == 3 {
            skipBtn.isHidden = false
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }
        if index == 4 {
            skipBtn.isHidden = false
            if self.getStartedButton.alpha == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }

    
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 5 {
            skipBtn.isHidden = true
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1
            })
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

