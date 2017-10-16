//
//  CardViewHelper.swift
//  vKclub
//
//  Created by HuySophanna on 20/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit
@IBDesignable class CardViewHelper: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = UIColor.black
    @IBInspectable let shadowOffSetWidth: Int = 0
    @IBInspectable let shadowOffSetHeight: Int = 1
    @IBInspectable var shadowOpacity: Float = 0.2
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
}
