//
//  PhoneCallPropertype.swift
//  vKclub Version 2
//
//  Created by Machintos-HD on 6/30/18.
//  Copyright © 2018 Pisal. All rights reserved.
//

import Foundation
import UIKit

class PhoneCellProperty {
    
    let buttonSegment : UISegmentedControl = {
        let array = ["Dailer", "Recents"]
        let buttonSegment = UISegmentedControl(items: array )
        buttonSegment.frame = CGRect(x: 0, y:0, width: 50 , height: 30)
        buttonSegment.selectedSegmentIndex = 0
        return buttonSegment
    }()
    
}
