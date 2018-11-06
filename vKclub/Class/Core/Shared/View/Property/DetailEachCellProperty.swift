//
//  DetailEachCellProperty.swift
//  vKclub
//
//  Created by Pisal on 7/26/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit

class DetailExploreEachCellVariables {
    
    struct ButtonId {
        static let callButton = "BOOK NOW"
        static let messageButton = "MESSAGE"
    }
    
    lazy var callButton: UIButton = DetailExploreEachCellVariables.ButtonForNameTitle(title: ButtonId.callButton)
    lazy var messageButton: UIButton = DetailExploreEachCellVariables.ButtonForNameTitle(title: ButtonId.messageButton)
    lazy var divideView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        return view
        
    }()
    lazy var horizontalDivideView: UIView = DetailExploreEachCellVariables.GetDivideLine()
    
    var detailCollectionView: UICollectionView!

    static func GetDivideLine() -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor =  UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
        return view
    }
    
    static func ButtonForNameTitle(title: String) -> ZFRippleButton {
        let button = ZFRippleButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.rippleColor = DetailExploreEachCellVariables.InitColor(buttonId: title)
        button.backgroundColor = DetailExploreEachCellVariables.InitColor(buttonId: title)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFCompactText-Regular", size: 16)
        return button
    }
    
    static func InitColor (buttonId: String) -> UIColor {
        if buttonId == ButtonId.callButton {
            let color = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
            return color
        }
        if buttonId == ButtonId.messageButton {
            
            let color = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
            
            return color
        }
        
        return UIColor.black
    }
    
}

