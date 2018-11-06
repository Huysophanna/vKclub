//
//  UserCoreData.swift
//  vKclub
//
//  Created by Pisal on 9/7/2561 BE.
//  Copyright © 2561 BE WiAdvance. All rights reserved.
//

import CoreData


class UserProfileCoreData {
    // check if user close the notification
    func CreatnotificationCoredata(_notification_num: Int , _notification_body: String,_notification_title : String ){
        let newNotification = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: manageObjectContext)
        newNotification.setValue(_notification_num, forKey: "notification_num")
        newNotification.setValue(_notification_body, forKey: "notification_body")
        newNotification.setValue(_notification_title, forKey: "notification_title")
        do{
            try  manageObjectContext.save()
        } catch {
            print("error")
        }
        
    }
    
    
    
    // Gets a person by id
    func getByIdUserProfile(_id: NSManagedObjectID) -> UserProfiles? {
        return manageObjectContext.object(with: _id) as? UserProfiles
    }
    
    func getCallDataByID (_id: NSManagedObjectID) -> SipCallData? {
        return manageObjectContext.object(with: _id) as? SipCallData
    }
    
    func updateUserProfile(_updatedPerson: UserProfiles){
        if let person = getByIdUserProfile(_id: _updatedPerson.objectID){
           
            person.imageData = _updatedPerson.imageData
            person.email     = _updatedPerson.email
            person.username  = _updatedPerson.username
            
            do{
                try  manageObjectContext.save()
                
            }catch{
                print("error")
            }
        }
        
    }
    
    func getUserProfile(withPredicate queryPredicate: NSPredicate) -> [UserProfiles] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfiles")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try manageObjectContext.fetch(fetchRequest)
            return response as! [UserProfiles]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [UserProfiles]()
        }
    }
    
    func deleteAllData(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try manageObjectContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                manageObjectContext.delete(managedObjectData)
                try manageObjectContext.save()
                
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func getSipCallDataFetchResult(withPredicate queryPredicate: NSPredicate) -> [SipCallData] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SipCallData")
        fetchRequest.predicate = queryPredicate
        do {
            let response = try manageObjectContext.fetch(fetchRequest)
            return response as! [SipCallData]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [SipCallData]()
        }
    }
    
    static func deleteAllData(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try manageObjectContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                manageObjectContext.delete(managedObjectData)
                try manageObjectContext.save()
                
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
}


