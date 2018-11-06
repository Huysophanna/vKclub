//
//  DetailProfileVariable.swift
//  vKclub
//
//  Created by Pisal on 7/16/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit
class ImageGridView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
    }
}
class DetailProfileVariables {
    
    
    struct membershipConstant {
        static let typeName = "SamboVisal"
        static let typeEmail = "someone@gmail.com"
        static let typeContent = "Type"
        static let pointContent = "Point"
        static let pointDetail = "200"
        static let typeDetail = "Silver"
        static let buttonPointHis = "Point History"
        static let buttonHowToEarnPoint = "How do I earn point?"
        static let membershipInfo = "Welcome to vKClub Point! With every book, you'll earn points. With your applicable points, you'll get new benefit within our resort."
    }
    
    lazy var detailProfileView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
        
    }()
    
    lazy var membershipBackground: UIImageView = {
       
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
     
        image.layer.masksToBounds = true
        image.image = UIImage(named: "membershipBackground")
        return image
        
    }()
    
    lazy var imageUserDetailProfileView: UIImageView = {
        
        let imageView = UIImageView()
        
       
        imageView.contentMode = .scaleAspectFill

        imageView.image = UIImage(named: "detailprofile-icon")
        imageView.image = imageView.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        imageView.clipsToBounds = true
    
        return imageView
        
        
    }()
    lazy var imageUserCircleView : ImageGridView = {
       
        let imageview = ImageGridView()
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.masksToBounds = true
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0).cgColor
        imageview.focusOnFaces = true
        imageview.debugFaceAware = true
        imageview.image = UIImage(named: "detailprofile-icon")
        imageview.image = imageview.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        imageview.backgroundColor = .white
        
        return imageview
    }()
    
    lazy var camera: UIImageView = {
        
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.masksToBounds = true
        imageview.image = UIImage(named: "camera")
        imageview.image = imageview.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        return imageview
    }()
    
    lazy var nameUserDetailProfileView: UILabel = DetailProfileVariables.initUserLabel(title: membershipConstant.typeName)
    lazy var emailUserDetailProfileView: UILabel = DetailProfileVariables.initUserLabel(title: membershipConstant.typeEmail)
    
    

    
    lazy var membershipDetailCardView: UIView = {
        
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        return view
    }()
    
    
    
    let divideView: UIView = {
        
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        return view
    }()
    lazy var simepleView: UIView = DetailProfileVariables.simpleView()
    
    lazy var membershipTypeLabel: UILabel = DetailProfileVariables.getMembershipLabel(titleName: membershipConstant.typeContent, fontSize: 22)
    
    lazy var membershipDetailType: UILabel = DetailProfileVariables.getMembershipLabel(titleName: membershipConstant.typeDetail, fontSize: 16)
    
    lazy var membershipPointLabel: UILabel = DetailProfileVariables.getMembershipLabel(titleName: membershipConstant.pointContent, fontSize: 22)
    
    lazy var membershipDetailPoint: UILabel = DetailProfileVariables.getMembershipLabel(titleName: membershipConstant.pointDetail, fontSize: 16)
    
    lazy var membershipDivideView: UIView = DetailProfileVariables.simpleView()
    lazy var memberTypeBackgroundView: UIView = DetailProfileVariables.simpleView()
    lazy var memberPointBackgroundView: UIView = DetailProfileVariables.simpleView()
    
    
    lazy var pointHistoryBtn: UIButton = DetailProfileVariables.getButtonWithName(titleName: membershipConstant.buttonPointHis)
    lazy var pointHistoryLabel: UILabel = DetailProfileVariables.getMembershipLabel(titleName: "Point History", fontSize: 16)
    
    lazy var pointHowEarnBtn: UIButton = DetailProfileVariables.getButtonWithName(titleName: membershipConstant.buttonHowToEarnPoint)
    
    
    lazy var membershipLabel: UILabel = DetailProfileVariables.membershipLabel(title: "vKclub Member")
    lazy var membershipInfo: UITextView = DetailProfileVariables.getUITextView(textView: membershipConstant.membershipInfo)
    
    
}
extension DetailProfileVariables {
    
    static func initUserLabel (title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.sizeToFit()
        label.minimumScaleFactor = 0.2
        
        if title == membershipConstant.typeName {
            label.font = UIFont(name: "SFCompactText-Bold", size: 22)
        } else {
            label.font = UIFont(name: "SFCompactText-Regular", size: 16)
            label.textColor = .gray
        }
        
        return label
    }
    
    static func getButtonWithName(titleName: String) -> UIButton {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.contentHorizontalAlignment = .right
        
        button.setImage(UIImage(named: "cancel-edit"), for: .normal)
        button.setTitle(titleName, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFCompactText-Regular", size: 13)
        return button
        
    }
    static func getUITextView(textView: String) -> UITextView {
        
        let text = UITextView()
        text.text = textView
        text.isEditable = false
        text.isSelectable = false
        text.isScrollEnabled = false
        text.translatesAutoresizingMaskIntoConstraints = false
      
        text.textColor = .black
        text.font = UIFont(name: "SFCompactText-Regular", size: 16)
        return text
        
    }
    
    static func membershipLabel (title: String) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = title
        label.font = UIFont(name: "SFCompactText-Bold", size: 22)
        label.textColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
        return label
    }
    
    static func getMembershipLabel (titleName: String, fontSize: CGFloat) -> UILabel{
        
        let label = UILabel()
        label.text = titleName
        label.textColor = getMembershipInitColor(title: titleName)
        if titleName == membershipConstant.typeContent || titleName == membershipConstant.pointContent{
            label.font = UIFont(name: "SFCompactText-Bold", size: fontSize)
        }else {
            
            label.font = UIFont(name: "SFCompactText-Regular", size: fontSize)
        }
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }
    static func getMembershipInitColor (title: String) -> UIColor {
        if title == membershipConstant.pointContent {
            return UIColor.orange
        }
        if title == membershipConstant.pointDetail {
            return UIColor.black
        }
        if title == membershipConstant.typeContent {
            return UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
        }else {
            return UIColor.black
        }
        
    }
    
    static func simpleView() -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }
    
    static func CGRectView () -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
        
        return view
    }
    
    
}
