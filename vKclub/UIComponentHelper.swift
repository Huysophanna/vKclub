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
    

}
