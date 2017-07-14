//
//  UIComponentHelper.swift
//  vKclub
//
//  Created by HuySophanna on 5/6/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func PresentAlertController(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UIColor {
    //Initializes a UIColor based off of a hex string
    convenience init(hexString:String, alpha:CGFloat){
        var cleanHex:String!
        //Eliminate common prefixes
        if(hexString.hasPrefix("#")){
            cleanHex = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 1))
        }
        else if(hexString.hasPrefix("0x")){
            cleanHex = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 2))
        }
        else{
            cleanHex = hexString
        }
        
        //Check for correct length
        if(cleanHex.characters.count != 6){
            self.init(red:0/255.0,green:0/255.0,blue:0/255.0, alpha: alpha)
        }
        else{
            let rString = cleanHex.substring(to: cleanHex.index(cleanHex.startIndex, offsetBy: 2))
            var gString = cleanHex.substring(from: cleanHex.index(cleanHex.startIndex, offsetBy: 2))
            gString = gString.substring(to: gString.characters.index(gString.startIndex, offsetBy: 2))
            var bString = cleanHex.substring(from: cleanHex.index(cleanHex.startIndex, offsetBy: 4))
            bString = bString.substring(to: bString.characters.index(bString.startIndex, offsetBy: 2))
            
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            self.init(red:CGFloat(r)/255.0,green:CGFloat(g)/255,blue:CGFloat(b)/255,alpha:alpha)
        }
    }
}

class UIComponentHelper {
    static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func PresentActivityIndicator(view: UIView!, option: Bool) {
        if option {
            //initialize opacity background while showing loading
            let opacityView: UIView = UIView()
            opacityView.frame = view.frame
            opacityView.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
            opacityView.tag = 50;
            
            //initialize activity indicator loading
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            //add subviews into the super view
            view.addSubview(activityIndicator)
            view.addSubview(opacityView)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        } else {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            //remove opacity views
            let removeOpacityView = view.viewWithTag(50)
            removeOpacityView?.removeFromSuperview()
        }
    }
    
    static func MakeWhitePlaceholderTextField(textfield: UITextField, name: String) {
        textfield.attributedPlaceholder = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func MakeBtnWhiteBorder(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        button.layer.cornerRadius = 8
        
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
    
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
    
    // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return newImage!
    }

}
