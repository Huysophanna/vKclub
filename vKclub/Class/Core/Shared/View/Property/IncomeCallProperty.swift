//
//  IncomeCallPropertype.swift
//  vKclub
//
//  Created by Machintos-HD on 7/12/18.
//  Copyright © 2018 WiAdvance. All rights reserved.
//

import Foundation
import UIKit


class IncomeCallProperty {
    
    let displayPhone : UILabel =  {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30.0)
        return label
    }()
    
    let speakerBtn : UIButton = {
        let button  = UIButton()
        button.setImage(UIImage(named: "speaker"), for: .normal)
        button.contentMode = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 0
        return button
        
    }()
    
    let muteBtn : UIButton = {
        let button  = UIButton()
        button.setImage(UIImage(named: "mute"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 0
        return button
        
    }()
    
    let displayStatus : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
        
    }()
    
    let recivedCallBtn : UIButton = {
        let button  = UIButton()
        return button
        
    }()
    
    let endCallBtn : UIButton = {
        let button  = UIButton()
        button.setTitle("End", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
        
    }()
    
    
    
    
    
   
}
