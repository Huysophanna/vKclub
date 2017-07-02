import UIKit
import CoreData

class MenuController: UIViewController {
   
   
    @IBOutlet weak var EmergencyBtn: UIButton!
    let User = UserProfile(context: context)
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var EditBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
       
        imageProfile.layer.cornerRadius = 10
        EditBtn.layer.borderColor = UIColor.green.cgColor
        EditBtn.layer.cornerRadius = 2;
        EditBtn.layer.borderWidth = 1;
        EmergencyBtn.layer.borderColor = UIColor.red.cgColor
        EmergencyBtn.layer.cornerRadius = 5;
        EmergencyBtn.layer.borderWidth = 2;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "UserProfile", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try context.fetch(fetchRequest)
            print(result)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
       
    }
    

    
    
}
