//
//  ButtonBorder.swift
//  vKclub
//
//  Created by HuySophanna on 28/6/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import Foundation
import UIKit

class ButtonBorder: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.white.cgColor
        
        let topBorder = UIView(frame: CGRect(x: 0,y:  0, width: frame.size.width * 3, height: 1))
        let leftBorder = UIView(frame: CGRect(x: 0,y:  0, width: 1, height: frame.size.height * 3))
        topBorder.backgroundColor = UIColor.white
        leftBorder.backgroundColor = UIColor.white
        addSubview(topBorder)
        addSubview(leftBorder)
    }
    
    
    
}
