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
    
    func StoreCallDataLog(_callerID: String , _callerName: String, _callDuration : String, _callIndicatorIcon: String) {
        let (year, month, date, hour, min, sec) = UIComponentHelper.GetTodayString()
        let timeStamp = "\(hour):\(min)"
        let callLogTime = "\(year)-\(month)-\(date)-\(hour)-\(min)-\(sec)"
        //Used to check and update duration into the this particular call log
        IncomingCallController.callLogTime = callLogTime
        
        let CallDataLog = NSEntityDescription.insertNewObject(forEntityName: "SipCallData", into: manageObjectContext)
        CallDataLog.setValue(_callDuration, forKey: "callDuration")
        CallDataLog.setValue(_callerID, forKey: "callerID")
        CallDataLog.setValue(_callerName, forKey: "callerName")
        CallDataLog.setValue(_callIndicatorIcon, forKey: "callIndicatorIcon")
        CallDataLog.setValue(timeStamp, forKey: "timeStamp")
        CallDataLog.setValue(callLogTime, forKey: "callLogTime")
        do {
            try manageObjectContext.save()
            RecentCallController.LoadCallDataCell()
        } catch {
            print("Could not save CallDataLog into CoreData \(error.localizedDescription) ===")
        }
    }
    
    // Gets a person by id
    func getByIdUserProfile(_id: NSManagedObjectID) -> UserProfile? {
        return manageObjectContext.object(with: _id) as? UserProfile
    }
    
    func getCallDataByID (_id: NSManagedObjectID) -> SipCallData? {
        return manageObjectContext.object(with: _id) as? SipCallData
    }
    
    func updateUserProfile(_updatedPerson: UserProfile){
        if let person = getByIdUserProfile(_id: _updatedPerson.objectID){
            person.facebookProvider = _updatedPerson.facebookProvider
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

    func getUserProfile(withPredicate queryPredicate: NSPredicate) -> [UserProfile] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try manageObjectContext.fetch(fetchRequest)
            return response as! [UserProfile]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [UserProfile]()
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
