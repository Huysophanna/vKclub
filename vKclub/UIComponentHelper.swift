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

}
