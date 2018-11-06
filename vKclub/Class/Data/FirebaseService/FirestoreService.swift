//
//  FirestoreService.swift
//  vKclub
//
//  Created by Pisal on 9/11/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


class FIRFireStoreService {
    
    private init () {}
    typealias FeedbackCompletionHandler = (_ success: Bool) -> Void
    static let shared = FIRFireStoreService()
    
    func collectionReferences(to collectionReference: FIRCollectionReference)-> CollectionReference {
        let setting = FirestoreSettings()
        setting.isPersistenceEnabled = true
        let db = Firestore.firestore()
        db.settings = setting
        switch collectionReference {
        case .feedback:
            return db.collection(collectionReference.rawValue)
        
        case .users:
            return db.collection(collectionReference.rawValue)
            
        default:
            return db.collection(collectionReference.rawValue)
        }
        
    }
  
    
    
    
    
  
}



