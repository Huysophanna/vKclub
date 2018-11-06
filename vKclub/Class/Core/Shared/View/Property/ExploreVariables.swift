//
//  ExploreVariables.swift
//  vKclub
//
//  Created by Pisal on 7/20/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import QuartzCore
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer


class ExploreVariables {
    
    static let getDeviceType = UIDevice.modelName
    
    struct ButtonName {
        static let settingButtonName = "Setting"
        static let mapButtonName = "Map"
        static let fileServerButtonName = "File Server"
        static let serviceButtonName = "Service"
        static let contactButtonName = "Contact Us"
        static let logoutButtonName = "Logout"
        static let feedBackBtnName = "Feedback"
        static let sosBtnName = "Emergency"
        static let editProfileBtnName = "Edit Profile"
    }
    
    lazy var mapButton: UIButton = ExploreVariables.InitUIButton(buttonName: ButtonName.mapButtonName)
    lazy var mapImage: UIImageView = ExploreVariables.InitImageButton(imageName: "location")
    lazy var mapContent: UILabel = ExploreVariables.InitTitileButton(titleName: "Map")
    
    // File sharing detail
    lazy var fileShareButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.fileServerButtonName)
    

    // * End of file sharing detail
    
    // Service detail
    lazy var serviceButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.serviceButtonName)

    
    // * End of service detail
    
    // Contact detail
    lazy var contactButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.contactButtonName)
    
    // * End of contact detail
    
    // Setting detail
    lazy var settingButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.settingButtonName)
 
    
    // Logout
    lazy var logoutButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.logoutButtonName)
    
    lazy var feedbackButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.feedBackBtnName)
    
    lazy var sosButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.sosBtnName)
    
    lazy var editProfileButton: MDCButton = ExploreVariables.InitUIButton(buttonName: ButtonName.editProfileBtnName)
}
extension ExploreVariables {
    
    struct FontName {
        static let SF_Regular = "SFCompactText-Regular"
    }
    
    static func InitUIButton (buttonName: String) -> MDCButton{
        
        let customFont : UIFont!
        let containedButton = MDCButton()
        let buttonScheme = MDCButtonScheme()
        let typographyScheme = MDCTypographyScheme()
        
        containedButton.translatesAutoresizingMaskIntoConstraints = false
//        containedButton.layer.cornerRadius = 5

        containedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        containedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: containedButton.imageEdgeInsets.left + 7, bottom: 0, right: 0)
        if buttonName.contains(ButtonName.fileServerButtonName) {
            containedButton.setTitle("Server", for: .normal)
            containedButton.setImage(UIImage(named: "filesharing"), for: .normal)
            
        }
        if buttonName.contains(ButtonName.serviceButtonName) {
            
            containedButton.setTitle("Stream", for: .normal)
            containedButton.setImage(UIImage(named: "stream"), for: .normal)
        }
        if buttonName.contains(ButtonName.contactButtonName) {
            containedButton.setTitle("Contact", for: .normal)
            containedButton.setImage(UIImage(named: "contact-us"), for: .normal)
        }
        if buttonName.contains(ButtonName.settingButtonName) {
            containedButton.setTitle("Setting", for: .normal)
            containedButton.setImage(UIImage(named: "setting"), for: .normal)
        }
        if buttonName.contains(ButtonName.logoutButtonName) {
            
            containedButton.setTitle("Logout", for: .normal)
            
        }
        if buttonName == ButtonName.feedBackBtnName {
            containedButton.setImage(UIImage(named: "feedback"), for: .normal)
            containedButton.setTitle("Feed back", for: .normal)
            
        }
        if buttonName == ButtonName.editProfileBtnName{
            containedButton.setImage(UIImage(named: "editprofile"), for: .normal)
            containedButton.setTitle("Edit Account", for: .normal)
            
        }
        if buttonName == ButtonName.sosBtnName {
            
            containedButton.setTitle("Emergency", for: .normal)
            containedButton.setImage(UIImage(named: "callsos"), for: .normal)
            
        }
        
        if getDeviceModelName.userDeviceIphone5() {
            
            customFont = UIFont(name: FontName.SF_Regular, size: 11)!
            containedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            containedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: containedButton.imageEdgeInsets.left + 5, bottom: 0, right: 0)
           
        }
        else if getDeviceModelName.userDeviceIphone678() {
            customFont = UIFont(name: FontName.SF_Regular, size: 12)!
           
        }
        else if getDeviceModelName.userDeviceIphone678Plus() {
            customFont = UIFont(name: FontName.SF_Regular, size: 14)!
            
        }
        else {
            
            customFont = UIFont(name: FontName.SF_Regular, size: 13)!
            
            
        }
        typographyScheme.button = customFont
        buttonScheme.typographyScheme = typographyScheme
        
        if buttonName == ButtonName.feedBackBtnName  || buttonName == ButtonName.editProfileBtnName{
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: containedButton)
            containedButton.backgroundColor = ExploreVariables.InitColor(forButtonName: buttonName)
            containedButton.alignVertical()
            containedButton.setElevation(ShadowElevation.none, for: .normal)
            containedButton.setShadowColor(UIColor(white: 255, alpha: 0), for: .normal)
            containedButton.layer.cornerRadius = 0
            
        }
        else if buttonName == ButtonName.logoutButtonName {
            
            MDCTextButtonThemer.applyScheme(buttonScheme, to: containedButton)
            containedButton.setElevation(ShadowElevation.none, for: .normal)
            containedButton.contentHorizontalAlignment = .left
            containedButton.setTitleColor(UIColor(red:1.00, green:0.44, blue:0.00, alpha:1.0), for: .normal)
            containedButton.layer.cornerRadius = 0
            
        }
        else if buttonName == ButtonName.sosBtnName {
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: containedButton)
            containedButton.backgroundColor = ExploreVariables.InitColor(forButtonName: buttonName)
            containedButton.contentHorizontalAlignment = .center
        }
        else {
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: containedButton)
            containedButton.backgroundColor = ExploreVariables.InitColor(forButtonName: buttonName)
            containedButton.contentHorizontalAlignment = .left
        }
        
        
        return containedButton
    }
  
    
    static func InitTitileButton (titleName: String) -> UILabel{
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = titleName
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        
        if getDeviceType.contains("SE") {
            label.font = UIFont(name: "SFCompactText-Regular", size: 12)
        } else {
            label.font = UIFont(name: "SFCompactText-Regular", size: 15)
        }
        
        
        return label
        
    }
    

    
    static func InitImageButton(imageName: String) -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: imageName)
        return image
    }
    static func InitColor (forButtonName: String) -> UIColor{
        let initColor: UIColor
        if forButtonName == ButtonName.settingButtonName {
            initColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
            
            return initColor
        }
        if forButtonName == ButtonName.contactButtonName {
            initColor = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
            
            return initColor
        }
        if forButtonName == ButtonName.serviceButtonName {
            initColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0)
            
            return initColor
        }
        if forButtonName == ButtonName.fileServerButtonName {
            initColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
            
            return initColor
        }
        if forButtonName == ButtonName.logoutButtonName {
            initColor = UIColor(red:1.00, green:0.44, blue:0.00, alpha:1.0)
            
            return initColor
        }
        if forButtonName == ButtonName.feedBackBtnName {
            initColor = UIColor(red:0.15, green:0.63, blue:0.85, alpha:1.0)
            return initColor
        }
        if forButtonName == ButtonName.editProfileBtnName {
            initColor = UIColor(red:0.17, green:0.33, blue:0.39, alpha:1.0)
            return initColor
        }
            
        if forButtonName == ButtonName.sosBtnName {
            initColor = UIColor(red:0.93, green:0.13, blue:0.23, alpha:1.0)
            
            return initColor
            
        }
            
        else {
            
            initColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
            return initColor
        }

        
    }
}
extension UIButton {
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedStringKey.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}
