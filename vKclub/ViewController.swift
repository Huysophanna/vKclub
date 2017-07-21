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
        
        return [ ("welcome-intro", "Welcome to vKapp", "Maximize your experience in vKirirom Pine Resort Discover, Explore, and Meet people with vKpp", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                 ("map-intro", "Map", "Digitalized map designed to help user get In-Touch with our vKirirom Pine Resort Services and Facilities", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                 ("voip-intro", "Voip", "Norestriction and Free Call", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                 ("sos-intro", "Emergency SOS", "Emergency SOS button guarantees users safety and help when lost in the forest or in dangerous situation", "", greenBackgroundColor , UIColor.white, UIColor.white, titleFont, descirptionFont),
                 ("mode-intro", "Onsite / Off-site Mode", "Experience all function of the app within On-site mode, while some including SOS, Voip are restricted for Off-site user.", "", greenBackgroundColor, UIColor.white, UIColor.white, titleFont, descirptionFont),
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
            
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }
        if index == 3 {
            
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }
        if index == 4 {
            
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }

    
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 5 {
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

