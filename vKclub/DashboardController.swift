//
//  DashboardController.swift
//  vKclub
//
//  Created by Machintos-HD on 6/22/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import UIKit

class DashboardController: UIViewController {
    
   
 
 
  
    
   
    
    
   
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Slidemenu()
        
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    
}
