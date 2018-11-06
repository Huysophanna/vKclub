//
//  KeypadPropertype.swift
//  vKclub Version 2
//
//  Created by Machintos-HD on 6/28/18.
//  Copyright © 2018 Pisal. All rights reserved.
//

import Foundation
import UIKit
class DialPadProperty {
    

    let cancelBtn : UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        return button
    }()
    
    let textField : UITextField = {
        
        let textField = UITextField()
        textField.allowsEditingTextAttributes = false
        textField.enablesReturnKeyAutomatically = false
        return textField
    
    }()
    
    let text1 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("1", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    
    let text2 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("2", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text3 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("3", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text4 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("4", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text5 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("5", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text6 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("6", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text7 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("7", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text8 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("8", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text9 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("9", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text10 :UIButton = {
        let text = UIButton(type: .custom)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.setTitle("*", for: .normal)
        text.setTitleColor(UIColor.black, for: .normal)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)

        
        return text
        
    }()
    let text0 :UIButton = {
        let text = UIButton(type: .custom)
        text.setTitle("0", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        return text
        
    }()
    let text11 :UIButton = {
        
        
        let text = UIButton(type: .custom)
        text.setTitle("#", for: .normal)
        text.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        text.titleLabel!.font = UIFont.boldSystemFont(ofSize: 30)
        text.setTitleColor(UIColor.black, for: .normal)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.widthAnchor.constraint(equalToConstant: 50).isActive = true
        text.heightAnchor.constraint(equalToConstant: 50).isActive = true
        text.setNeedsLayout()
        text.layoutIfNeeded()

        
        return text
        
    }()
    let call :UIButton = {
        let text = UIButton(type: .custom)
        text.backgroundColor = UIColor(red: 0/255, green: 219/255, blue: 47/255, alpha: 1.0)
        
        text.setTitleColor(UIColor.black, for: .normal)
        
        text.setImage(UIImage(named: "phoneCall"), for: .normal)
        return text
        
    }()
    
    
    

    
   
}
