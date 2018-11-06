//
//  UIViewProperty.swift
//  vKclub
//
//  Created by Pisal on 7/24/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
import ReadMoreTextView
import MaterialComponents.MaterialCards

class ExploreCategoryComponents {
    
  
    
    let getDeviceType = UIDevice.modelName
    
    lazy var collectionViewInstance: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: flowLayout)
        collectionView.backgroundColor =  .white
        collectionView.alwaysBounceHorizontal = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        
    }()
    lazy var mainCardView: MDCCard = {
        
        let view = MDCCard()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.isUserInteractionEnabled = false

        return view
        
    }()
    
    lazy var categoryImageContent: UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 17
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "pineresort")
        return image
        
    }()
    
 
    
    lazy var cardView: MDCCard = {
        
        let view = MDCCard()
        
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowOffset = CGSize(width: 0, height: 10)
//        view.layer.shadowRadius = 10
        return view
        
    }()
    
    lazy var categoryShortDetailLabel: ReadMoreTextView = {
        
        let readView = ReadMoreTextView()
       
        readView.textColor = .black
        readView.isEditable = false
        readView.isSelectable = false
        readView.maximumNumberOfLines = 3
        readView.shouldTrim = true
        readView.translatesAutoresizingMaskIntoConstraints = false
        readView.backgroundColor = UIColor(white: 255, alpha: 0)
        if getDeviceModelName.userDeviceIphone5() {
            readView.font = UIFont(name: "SFCompactText-Regular", size: 12)
        }
        else if getDeviceModelName.userDeviceIphone678() {
            readView.font = UIFont(name: "SFCompactText-Regular", size: 14)
        }
        else if getDeviceModelName.userDeviceIphone678Plus() {
            readView.font = UIFont(name: "SFCompactText-Regular", size: 16)
        }
        else {
           readView.font = UIFont(name: "SFCompactText-Regular", size: 15)
        }
        
        return readView
        
    }()
    let categoryDetailContent: UILabel = {
        
        let categoryDetailContent = UILabel()
        categoryDetailContent.numberOfLines = 10
        categoryDetailContent.text = "Content describes particular accommodation. This can be many lines of content as you want, but based on the main view."
        categoryDetailContent.translatesAutoresizingMaskIntoConstraints = false
        
        if getDeviceModelName.userDeviceIphone5() {
            categoryDetailContent.font = UIFont(name: "SFCompactText-Regular", size: 14)
        }
        else if getDeviceModelName.userDeviceIphone678() {
            categoryDetailContent.font = UIFont(name: "SFCompactText-Regular", size: 15)
        }
        else if getDeviceModelName.userDeviceIphone678Plus() {
            categoryDetailContent.font = UIFont(name: "SFCompactText-Regular", size: 16)
        } else {
            
            categoryDetailContent.font = UIFont(name: "SFCompactText-Regular", size: 15)
        }
        
        return categoryDetailContent
    }()
    
    lazy var exploreCategoryLabel: UILabel = {
        
        let categoryLabel = UILabel()
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "Description"
        categoryLabel.textColor = .black
        categoryLabel.numberOfLines = 2
        
        if getDeviceModelName.userDeviceIphone5() {
            categoryLabel.font = UIFont(name: "SFCompactText-Bold", size: 18)
        }
        else if getDeviceModelName.userDeviceIphone678() {
            categoryLabel.font = UIFont(name: "SFCompactText-Bold", size: 20)
        }
        else if getDeviceModelName.userDeviceIphone678Plus(){
           
            categoryLabel.font = UIFont(name: "SFCompactText-Bold", size: 22)
        } else {
            
            categoryLabel.font = UIFont(name: "SFCompactText-Bold", size: 22)
        }
        
        
        return categoryLabel
        
    }()
    
    lazy var exploreNameLabel: UILabel = {
        let name = UILabel()
        
        if getDeviceModelName.userDeviceIphone5() {
            name.font = UIFont(name: "SFCompactText-Regular", size: 12)
        }
        else if getDeviceModelName.userDeviceIphone678() {
            name.font = UIFont(name: "SFCompactText-Regular", size: 14)
        }
        else {
            name.font = UIFont(name: "SFCompactText-Regular", size: 16)
        }
       
        name.numberOfLines = 2
        name.text = "Name of accomodation"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var exploreImageView: CardImageView = {
        
        let imageView = CardImageView()
        
        imageView.image = UIImage(named: "pineresort")
        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        return imageView
        
        
    }()
    
    lazy var viewAllCategory: UIButton = {
        
        let button = UIButton()
        button.setTitle("View All", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0), for: .normal)
        button.setTitleColor(UIColor(red:0.00, green:0.10, blue:0.00, alpha:1.0), for: UIControlState.highlighted)
        
        if getDeviceModelName.userDeviceIphone5() {
            button.titleLabel?.font = UIFont(name: "SFCompactText-Regular", size: 12)
        }
        if getDeviceModelName.userDeviceIphone678(){
            button.titleLabel?.font = UIFont(name: "SFCompactText-Regular", size: 14)
        }
        else {
           button.titleLabel?.font = UIFont(name: "SFCompactText-Regular", size: 16)
        }
        
        
        button.sizeToFit()
        
        return button
    }()
}


class CardImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.curveImageToCorners()
    }
    
    func curveImageToCorners() {
        // The main image from the xib is taken from: https://unsplash.com/photos/wMzx2nBdeng
        // License details: https://unsplash.com/license
        var roundingCorners = UIRectCorner.topLeft
        if (UIDevice.current.orientation == .portrait ||
            UIDevice.current.orientation == .portraitUpsideDown) {
            roundingCorners.formUnion(.topRight)
        } else {
            roundingCorners.formUnion(.bottomLeft)
        }
        
        let bezierPath = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: roundingCorners,
                                      cornerRadii: CGSize(width: 4,
                                                          height: 4))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
    
}
