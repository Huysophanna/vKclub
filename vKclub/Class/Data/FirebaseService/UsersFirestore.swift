//
//  UsersFirestore.swift
//  vKclub
//
//  Created by Pisal on 9/13/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import Foundation
import Firebase
// User firestore
extension FIRFireStoreService {
    
    /// Store user information such as: Email, and password in order to verify when user login to our sever in Firestore
    /**
     - Parameters:
        - encodableObject: The cubes available for allocation
        - collectionReference: The people that require cubes
     */
    func createUserFirestore <T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference,  completion: @escaping FeedbackCompletionHandler) {
        
        do {
            
            let json = try encodableObject.toJson(excluding: ["id"])
            
            collectionReferences(to: collectionReference).addDocument(data: json, completion: { (error) in
                if let err = error {
                    print("error add document ", err)
                    completion(false)
                } else {
                    completion(true)
                }
            })
            
        } catch {
            print(error)
        }
        
    }
    func loginUserFirestore <T: Encodable & Decodable>(for encodableObject: T, in collectionReference: FIRCollectionReference,  returning objectType: T.Type, completion: @escaping FeedbackCompletionHandler) {
        
        do {
            
            let json = try encodableObject.toJson()
            
            let d = collectionReferences(to: .users).whereField("email", isEqualTo: json["email"] as! String)
            let datas = self.collectionReferences(to: collectionReference)
            d.getDocuments { (data, error) in
                if let err = error {
                    print("Error ", err)
                } else {
                    if (data?.isEmpty)! {
                        
                        datas.addDocument(data: json, completion: { (err) in
                            
                            if let error = err {
                                print("Error ", error)
                                completion(false)
                            } else {
                                completion(true)
                            }
                            
                            
                        })
                    } else {
                        guard let snapshot = data else  {
                            return
                        }
                        
                        do {
                            
                            
                            //print("user id ",id)
                            for document in snapshot.documents {
                                let object = try document.decode(as: objectType.self)
                                print("Json data ", object)
                                
                            }
                            
                        }catch {
                            print(error)
                        }
                       
                        completion(true)
                    }
                }
                
            }
            
            
        } catch {
            print(error)
        }
        
    }
    func readUserProfileFirestore<T: Encodable & Decodable>(for encodableObject: T, in collectionReference: FIRCollectionReference,  returning objectType: T.Type, completion: @escaping ([T] ,_ sucess: Bool) -> Void) {
        
        
        do {
            let json = try encodableObject.toJson()
            print("Json data ",json.count)
            let d = collectionReferences(to: .users).whereField("email", isEqualTo: json["email"] as! String)
            d.getDocuments(completion: { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                do {
                    
                    var objects = [T]()
                    for document in snapshot.documents {
                        let object = try document.decode(as: objectType.self)
                        print("UpdateJson data ", object)
                        objects.append(object)
                    
                    }
                    if objects.count > 0 {
                        
                        completion(objects, true)
                    } else {
                        completion(objects, false)
                    }
                    
                }catch {
                    print(error)
                }
            })
            
        } catch {
            print(error)
        }
    }
    
    // Update user EMAIL, USERNAME
    func updateUserFirestore<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            
            let json = try encodableObject.toJson(excluding: ["id"])
            print("Json data updating ", json)
            guard let id = encodableObject.id else { throw MyError.encodingError }
            print("Id user is ", id)
            collectionReferences(to: collectionReference).document(id).setData(json)
            
        } catch {
            print(error)
        }
        
        
        
    }
    
    
//    func feedbackFirestore <T: Encodable & FeedbackID>(for encodableObject: T, in collectionReference: FIRCollectionReference, completion: @escaping FeedbackCompletionHandler) {
//        
//        do {
//            var json = try encodableObject.toJson(excluding: ["id"])
//            //guard let id = encodableObject.id else {throw MyError.encodingError}
//            // print("Feedback id ", id)
//        
//            json["timestamp"] = FieldValue.serverTimestamp()
//          
//            collectionReferences(to: .feedback).addDocument(data: json, completion: { (error) in
//                if let error = error {
//                    print(error)
//                    completion(false)
//                } else {
//                    print(json)
//                    completion(true)
//                }
//            })
//            
//        } catch {
//            print(error)
//        }
//        
//    }
    
}
