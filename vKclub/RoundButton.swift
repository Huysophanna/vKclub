//
//  RoundButton.swift
//  vKclub
//
//  Created by HuySophanna on 6/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = borderRadius
        }
    }
    
//    @IBInspectable var imageButton: UIImage = UIImage(named: "reject-phone-icon")! {
//        didSet{
//            self.setImage(self.imageButton, for: .normal)
//            self.contentMode = .center
//            self.imageView?.contentMode = .scaleAspectFit
//            self.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
//        }
//        
//    }

}
