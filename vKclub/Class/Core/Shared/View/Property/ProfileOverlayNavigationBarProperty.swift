//
//  ProfileVariable.swift
//  vKclub
//
//  Created by Pisal on 7/16/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit


class ProfileOverlayNavigationBar {
    
    lazy var imageUser: UIImageView = {
        
        
        let imageView = UIImageView()
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "pineresort")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    lazy var opacityDetailEachExplore: UIImageView = {
        
        
        let view = UIImageView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.40)
        view.isOpaque = false
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    lazy var opacityImageUser: UIImageView = {
       
        let view = UIImageView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.80)
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileView: UIView = ProfileOverlayNavigationBar.getView()
    lazy var detailView: UIView = ProfileOverlayNavigationBar.getView()
    
    static func getView()-> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    
}
