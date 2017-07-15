//
//  NotificationController.swift
//  vKclub
//
//  Created by Machintos-HD on 7/9/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit

class NotificationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    

}
