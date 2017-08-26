//
//  UIComponentHelper.swift
//  vKclub
//
//  Created by HuySophanna on 5/6/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension UIViewController {
    func PresentAlertController(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 168
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
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
    
    static func scheduleNotification(_title: String, _body: String, _inSeconds: TimeInterval) {
        let localNotification = UNMutableNotificationContent()
        
        localNotification.title = _title
        localNotification.body = _body
        
        let localNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: _inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "localNotification", content: localNotification, trigger: localNotificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error == nil {
                print("LocalNotificationSuccess =====")
            } else {
                print("LocalNotificationError  ===== ", error?.localizedDescription as Any)
            }
        })
        
    }
    
    static func PresentActivityIndicatorWebView(view: UIView!, option: Bool) {
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
           
        } else {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            //remove opacity views
            let removeOpacityView = view.viewWithTag(50)
            removeOpacityView?.removeFromSuperview()
        }
    }
    
    static func MakeCustomPlaceholderTextField(textfield: UITextField, name: String, color: UIColor) {
        textfield.attributedPlaceholder = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: color])
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func MakeBtnWhiteBorder(button: UIButton, color: UIColor) {
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
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
    
    // Find out current date YYYY/MM/DD/HH/MM/SS
    static func GetTodayString() -> (String, String, String, String, String, String) {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        var am_pm = ""
        let year = components.year
        let month = components.month! < 10 ? "0" + String(components.month!) : String(components.month!)
        let day = components.day! < 10 ? "0" + String(components.day!) : String(components.day!)
        var hour = components.hour! < 10 ? "0" + String(components.hour!) : String(components.hour!)
        
        if Int(hour)! > 12 {
            hour = String((Int(hour)!) - 12)
            am_pm = "PM"
        } else {
            am_pm = "AM"
        }
        
        let minute = components.minute! < 10 ? "0" + String(components.minute!) + am_pm : String(components.minute!) + am_pm
        let second = components.second! < 10 ? "0" + String(components.second!) : String(components.second!)

        return (String(year!), String(month), String(day), String(hour), String(minute), String(second))
    }
    static func LocationPermission(INAPP_UNIDENTIFIEDSetting : Bool){
        let LocationPermissionAlert = UIAlertController(title: "Location Permission Denied.", message: "Turn on Location Service to Determine your current location for App Mode", preferredStyle: UIAlertControllerStyle.alert)
        
        LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            if INAPP_UNIDENTIFIEDSetting {
                
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
            } else{
                UIApplication.shared.open(URL(string:"App-Prefs:root=Privacy")!, options: [:], completionHandler: nil)
            }
            
        }))
        LocationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present( LocationPermissionAlert, animated: true, completion: nil)
    }
    static func AvoidSpecialCharaters(specialcharaters : String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
       
        if specialcharaters.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            return false
        }
        
        return true
    }
    static func Countwhitespece(_whitespece : String) -> Int{
        let regex = try! NSRegularExpression(pattern: "\\s")
        let numberOfWhitespaceCharacters = regex.numberOfMatches(in: _whitespece , range: NSRange(location: 0, length: _whitespece.utf16.count))
        return numberOfWhitespaceCharacters
        
    }
    static func Whitespeceatbeginning(_whitespece : String) -> Bool{
        let i : String = _whitespece
        let r = i.index(i.startIndex, offsetBy: 1)
        let url : String = (i.substring(to: r))
        if url == " " {
           
            return true
        }
      return false
    }
    
    
    
    

}
