import CoreData
class PersonService {
    // Creates a new Person
    func CreatnotificationCoredata(_notification_num: intmax_t , _notification_body: String,_notification_title : String ) -> Notifications{
        let newNotification = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: manageObjectContext)
        newNotification.setValue(_notification_num, forKey: "notification_num")
        newNotification.setValue(_notification_body, forKey: "notification_body")
        newNotification.setValue(_notification_title, forKey: "notification_title")
        do{
           try  manageObjectContext.save()
            
        }catch{
            print("error")
        }
        return newNotification as! Notifications
    }
    
    // Gets a person by id
    func getById(_id: NSManagedObjectID) -> UserProfile? {
        return manageObjectContext.object(with: _id) as? UserProfile
    }
    
    func updateUserProfile(_updatedPerson: UserProfile){
        if let person = getById(_id: _updatedPerson.objectID){
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
    func get(withPredicate queryPredicate: NSPredicate) -> [UserProfile]{
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
    
      
}
