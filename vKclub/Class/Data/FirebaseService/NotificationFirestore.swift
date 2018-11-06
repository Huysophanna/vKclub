//
//  NotificationFirestore.swift
//  vKclub
//
//  Created by Pisal on 9/17/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import Foundation
import Firebase

extension FIRFireStoreService {
    
    
    func addUserNotification<T: Encodable> (for encodableObject: T, in collectionReference: FIRCollectionReference,  completion: @escaping FeedbackCompletionHandler) {
        
        do {
            
            let json = try encodableObject.toJson(excluding: ["id"])
            collectionReferences(to: collectionReference).document(UserDefaults.standard.getUserId()).collection("notifications").addDocument(data: json) { (error) in
                if error == nil {
                    completion(true)
                }
            }
            
        } catch {
            print("eror" , error)
        }
        
        
    }
    
    
    func readUserNotifications<T: Decodable>(from collectionReference: FIRCollectionReference, get userId: String, returning objectType: T.Type, fromType collectionCell: FIRCollectionCell, completion: @escaping ([T], _ sucess: Bool) -> Void)  {
        
    
        collectionReferences(to: collectionReference).document(userId).collection(collectionCell.rawValue).addSnapshotListener { (snapshot, error) in
            var objectsAppend = [T]()
            
            objectsAppend.removeAll()
            if let error = error {
                print(error.localizedDescription)
            }
            guard let snapshot = snapshot else {
                print("Doesn't have snapshot")
                return
            }
            
            do {
                for document in snapshot.documents {
                    print("Document notification ", document.data())
                    let object = try document.decode(as: objectType.self)
                    objectsAppend.append(object)
                    
                }
                if objectsAppend.isEmpty {
                    objectsAppend.removeAll()
                    completion(objectsAppend, false)
                } else {
                    completion(objectsAppend, true)
                }
            } catch {
                completion(objectsAppend, false)
                print(error)
            }
        }

    }
    
    func queryTimestamp() {
        
        
        collectionReferences(to: .users).document(UserDefaults.standard.getUserId()).collection("timestamp").order(by: "stamp").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("Document id ", document.documentID)
                    print("Document data ", document.data())
                    let documentData = document.data()
                    print("Timestamp ", documentData["stamp"] )
                    print("Type of it ", type(of: documentData["stamp"]))
                    let ts = documentData["stamp"]
                    
                    let json = Timestamp(stamp: documentData["stamp"])
                    
                    print("Document json ", json)
                }
                
            }
        }
    }
    
    // delete particular notification
    func delete(get notificationId: String, in collectionReference: FIRCollectionReference) {
        
        collectionReferences(to: collectionReference).document(UserDefaults.standard.getUserId()).collection("notifications").document(notificationId).delete()
        
    }
    
    // Not working yet
    func deleteAllDocumentsNotificaiton(in collectionReference: FIRCollectionReference, completion: @escaping FeedbackCompletionHandler) {
        collectionReferences(to: collectionReference).document(UserDefaults.standard.getUserId()).collection("notifications").getDocuments { (snapshot, error) in
            if error == nil {
                guard let snapshot = snapshot else {
                    completion(false)
                    return
                }
                for docuemnts in snapshot.documents {
                    
                    let data = docuemnts.data()
                    print("Data notifications ", data)
                }
                
            }
        }
        
    }
}
