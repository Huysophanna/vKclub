//
//  UIComponentsHelper.swift
//  vKclub Version 2
//
//  Created by Machintos-HD on 7/2/18.
//  Copyright © 2018 Pisal. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SVProgressHUD
import ProgressHUD
import PopupDialog

class UIComponentHelper {
    
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
    static func showProgressWith(status: String, interact: Bool) {
        
        ProgressHUD.show(status, interaction: interact)
    
        
    }
    static func showProgressError() {
    
        ProgressHUD.showError()
        
    }
    static func showProgressError(status: String) {
        
        ProgressHUD.showError(status)
        
        
    }
    static func svProgressDismiss() {
        SVProgressHUD.dismiss()
    }
    static func ProgressDismiss() {
        ProgressHUD.dismiss()
    }
    static func showProgressStatus(status: String) {
        ProgressHUD.show(status)
    }
    static func showProgressSucc() {
        ProgressHUD.showSuccess()
    }
    static func showProgressSucc(status: String){
        
        ProgressHUD.showSuccess(status)
    }
    
}

extension UIViewController {
    
    func PresentAlertController(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func PresentDialogOneActionController(title: String, message: String, actionTitle: String) {
        
        self.CustomPopupDialogView()
        
        let alertController = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .bounceUp, preferredWidth: view.frame.width / 1.3, gestureDismissal: true, hideStatusBar: false) {
            
        }
        
        
        let okayButton = DefaultButton(title: actionTitle) {
            print("Okay Button")
        }
        alertController.addButton(okayButton)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func SVProgressShowLoading () {
        SVProgressHUD.setDefaultMaskType(.clear)
        
        SVProgressHUD.show(withStatus: "Loading...")
    }
    func SVProgressShowLoadingInteract() {
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    func SVProgressDismiss() {
        SVProgressHUD.dismiss()
    }
    
    func CustomPopupDialogView () {
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.titleFont = UIFont(name: "SFCompactText-Bold", size: 22)!
        dialogAppearance.titleColor = UIColor.black
        dialogAppearance.messageFont = UIFont(name: "SFCompactText-Regular", size: 16)!
        dialogAppearance.messageColor = UIColor.black
        
        let buttonAppearance = DefaultButton.appearance()
        buttonAppearance.titleFont = UIFont(name: "SFCompactText-Regular", size: 16)!
        buttonAppearance.titleColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
        
        let buttonCancel = CancelButton.appearance()
        buttonCancel.titleColor = UIColor.black
        buttonCancel.titleFont = UIFont(name: "SFCompactText-Regular", size: 16)!
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    func userId() -> String{
        return UserDefaults.standard.getUserId()
    }
    func isEnableBadgeView() -> Bool{
        return UserDefaults.standard.isEnableBadgeView()
    }
    func showLoadingProgress() {
        SVProgressShowLoading() 
    }
    
}
extension UserDefaults {
    
    func setupEnableBadgeView(value: Bool) {
        set(value, forKey: "isEnableBadgeView")
        synchronize()
    }
    func isEnableBadgeView() -> Bool {
        return bool(forKey: "isEnableBadgeView")
    }
    
    
    func setIsLoggedIn(value: Bool){
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    
    func setUserId(value: String) {
        set(value, forKey: "userID")
        synchronize()
    }
    func getUserId() -> String {
        
        return value(forKey: "userID") as! String
        
    }
    
}

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
    
}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x: contentOffset, y: self.contentOffset.y , width: self.frame.width, height: self.frame.height)
        self.scrollRectToVisible(frame, animated: true)
    }
}

extension UIApplication {
    typealias BackgroundTaskCompletion = () -> Void
    func executeBackgroundTask(f: (BackgroundTaskCompletion) -> Void) {
        let identifier = beginBackgroundTask {
            // nothing to do here
        }
        f() { [unowned self] in
            self.endBackgroundTask(identifier)
        }
    }
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
extension UIButton {
    
    func animatePulse () {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1
        layer.add(pulse, forKey: nil)
    }
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

