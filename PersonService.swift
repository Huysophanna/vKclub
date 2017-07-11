import CoreData

class PersonService{
    
   
    
    // Creates a new Person
    func create(facebook: Bool, imageData: NSData ) -> UserProfile{
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: context)
         newItem.setValue(facebook, forKey: "facebook")
         newItem.setValue(facebook, forKey: "imageData")
         return newItem as! UserProfile
    }
    
    // Gets a person by id
    func getById(id: NSManagedObjectID) -> UserProfile? {
        return context.object(with: id) as? UserProfile
    }
    
    func update(updatedPerson: UserProfile){
        if let person = getById(id: updatedPerson.objectID){
            person.facebookProvider = updatedPerson.facebookProvider
            person.imageData = updatedPerson.imageData
            person.email     = updatedPerson.email
            person.username  = updatedPerson.username
        }
        
    }
    
        
    
   func get(withPredicate queryPredicate: NSPredicate) -> [UserProfile]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.fetch(fetchRequest)
            return response as! [UserProfile]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [UserProfile]()
        }
    }
    
      
}
