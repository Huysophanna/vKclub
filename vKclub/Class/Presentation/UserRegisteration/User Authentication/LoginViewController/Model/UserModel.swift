//
//  LoginViewModel.swift
//  vKclub
//
//  Created by Pisal on 9/11/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String? {get set}
}

struct UserModel: Codable , Identifiable{

    var id: String? = nil
    var `extension`: String?
    var email: String?
    var password: String?
    var username: String?
    
    
    init(`extension`: String, password: String, username: String, email: String) {
    
        self.`extension` = `extension`
        self.password = password
        self.username = username
        self.email = email
    }
    
    
}

