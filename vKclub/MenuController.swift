import UIKit
import CoreData
import Firebase
import Photos
import MessageUI


class MenuController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate {
    
    let personService = PersonService()
    let Checklocation = DashboardController()
    var email :String = ""
    let currentuser = Auth.auth().currentUser

    @IBOutlet weak var EmergencyBtn: UIButton!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var imageProfile: UIButton!
    @IBOutlet weak var urlTextView: UITextField!
    
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBProvider()
        EmailProvider()
        imageProfile.layer.cornerRadius = 50
        EditBtn.layer.borderColor = UIColor.green.cgColor
        
        //make responsive rounded user profile picture
        imageProfile.frame = CGRect(x: EditBtn.frame.origin.x, y: imageProfile.bounds.width / 5, width: (view.bounds.width * 35) / 100, height: (view.bounds.width * 35) / 100)
        imageProfile.layer.cornerRadius = imageProfile.bounds.width / 2
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout(_ sender: Any) {
        deleteAllData(entity: "UserProfile")
        try! Auth.auth().signOut()
        if self.storyboard != nil {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginController") as! LoginController
            self.present(newViewController, animated: true, completion: nil)
            
        }
        
        
    }
    func FBProvider(){
        let facebookProvider = NSPredicate(format: "facebookProvider = 1")
        let fb_lgoin = personService.get(withPredicate: facebookProvider)
        for i in fb_lgoin {
            EditBtn.isHidden = true
//            FBlinked.setTitle("FB link", for: .normal)
            let img = UIImage(data: i.imageData as! Data)
            let newimag = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 150, height: 100))
            imageProfile.setImage(newimag, for: .normal)
            print(i.username)
            userName.text = i.username
            email = i.email!
        }
    }
    
    @IBAction func didTapTakePicture(_ sender: Any) {
        let pickerController = UIImagePickerController()
        present(pickerController, animated: true, completion: nil)
    }
    
    func EmailProvider(){
        let emailProvider = NSPredicate(format: "facebookProvider = 0")
        let email_lgoin = personService.get(withPredicate: emailProvider)
        for i in email_lgoin {
//            FBlinked.isHidden = true
            
            if i.facebookProvider != true {
             
              EditBtn.addTarget(self,action: #selector(EditProfile), for: .touchUpInside)
            }
            
            let img = UIImage(data: i.imageData as! Data)
            let newimag = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 150, height: 100))
            imageProfile.setImage(newimag, for: .normal)
            userName.text = currentuser?.displayName
            
            
        }
    }
    func EditProfile(){
        performSegue(withIdentifier:"GotoEditProfile", sender: self)

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
    
    @IBAction func EmergencySOS(_ sender: Any){
        let Check : String =  Checklocation.CheckUserLocation()
        if Check == "inKirirom" {
            self.inKirirom()
            
        } else if (Check == "offKirirom") {
            PresentAlertController(title: "Something went wrong", message: "You off kirirom,so You can not use EmergencySOS function", actionTitle: "Got it")
        } else if( Check == "identifying"){
            PresentAlertController(title: "Something went wrong", message: "Please Allow your location", actionTitle: "Got it")
        } else {
            PresentAlertController(title: "Something went wrong", message: "Please Allow your location", actionTitle: "Got it")
        }
        
    }
    
    func inKirirom() {
        let smsAlert = UIAlertController(title: "EmergencySOS", message: "We will generate a SMS along with your current location to our supports. We suggest you not to move far away from your current position, as we're trying our best to get there as soon as possible. \n (Standard SMS rates may apply)", preferredStyle: UIAlertControllerStyle.alert)
        
        smsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.SMS()
        }))
        
        smsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(smsAlert, animated: true, completion: nil)
        
        
    }
    //send SMS
    func SMS() {
                let currentLocaltion_lat = String(Checklocation.lat)
        let currentLocation_long = String(Checklocation.long)
        print(currentLocaltion_lat)
        if (MFMessageComposeViewController.canSendText()) {
            let phone = "+13343758067"
            let message = "Please help! I'm currently facing an emergency problem. Here is my Location: http://maps.google.com/?q="+currentLocaltion_lat+","+currentLocation_long+""
            
            let controller = MFMessageComposeViewController()
            controller.body = message
            controller.recipients = [phone]
            controller.messageComposeDelegate = self as MFMessageComposeViewControllerDelegate
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    
    @IBAction func settingBtn(_ sender: Any) {
        performSegue(withIdentifier:"GotoSetting", sender: self)
    }
    
    
    @IBAction func contactusBtn(_ sender: Any) {
        let contactusAlert = UIAlertController(title: "Contact us", message: "", preferredStyle: .actionSheet)
        
        contactusAlert.addAction(UIAlertAction(title:"English Speaker   010905998", style:.default,handler: nil))
        contactusAlert.addAction(UIAlertAction(title:"Ok", style:.default,handler: nil))
        self.present(contactusAlert,animated: true)
    }
}


