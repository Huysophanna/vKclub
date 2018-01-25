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
    
    @IBInspectable var btnBackgroundColor: UIColor = UIColor.clear {
        didSet {
            self.backgroundColor = btnBackgroundColor
        }
    }

    
}
