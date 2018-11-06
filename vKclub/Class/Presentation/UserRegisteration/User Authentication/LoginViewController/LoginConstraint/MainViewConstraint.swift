//
//  ConstraintMainView.swift
//  vKclub
//
//  Created by Pisal on 8/3/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import UIKit

// Constrain Main View
extension LoginViewController {
    
    func constraintProfileView() {
        
        profileVariables.profileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileVariables.profileView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileVariables.profileView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileVariables.profileView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        profileVariables.profileView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        profileVariables.profileView.backgroundColor = .red
        
    }
    func constraintViewBelowProfileView() {
        
        detailProfileVariables.detailProfileView.topAnchor.constraint(equalTo: profileVariables.profileView.bottomAnchor).isActive = true
        detailProfileVariables.detailProfileView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        detailProfileVariables.detailProfileView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailProfileVariables.detailProfileView.backgroundColor = .white
        
        
    }
    
    func profileViewSubview() {
        
        profileVariables.profileView.addSubview(profileVariables.imageUser)
        profileVariables.imageUser.addSubview(profileVariables.opacityDetailEachExplore)
        
        profileVariables.opacityDetailEachExplore.topAnchor.constraint(equalTo: profileVariables.imageUser.topAnchor).isActive = true
        profileVariables.opacityDetailEachExplore.leftAnchor.constraint(equalTo: profileVariables.imageUser.leftAnchor).isActive = true
        profileVariables.opacityDetailEachExplore.rightAnchor.constraint(equalTo: profileVariables.imageUser.rightAnchor).isActive = true
        profileVariables.opacityDetailEachExplore.heightAnchor.constraint(equalTo: profileVariables.profileView.heightAnchor).isActive = true
        
    }
    
    func constraintImageCoverView() {
        
        profileVariables.imageUser.topAnchor.constraint(equalTo: profileVariables.profileView.topAnchor).isActive = true
        profileVariables.imageUser.leftAnchor.constraint(equalTo: profileVariables.profileView.leftAnchor).isActive = true
        profileVariables.imageUser.rightAnchor.constraint(equalTo: profileVariables.profileView.rightAnchor).isActive = true
        profileVariables.imageUser.heightAnchor.constraint(equalTo: profileVariables.profileView.heightAnchor).isActive = true
        
    }
    
}
