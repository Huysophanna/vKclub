import UIKit
import CoreData
import Firebase
import Photos
import MessageUI


class MenuController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate {
    var imagePicker : UIImagePickerController = UIImagePickerController()
    
    let personService = PersonService()
    let Checklocation = DashboardController()
    let storageRef = Storage.storage().reference()
    let currentUser = Auth.auth().currentUser
    var loginControllerInstance: LoginController = LoginController()
    var facebookCheck : Bool = false
    @IBOutlet weak var EmergencyBtn: UIButton!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var imageProfile: UIButton!
    @IBOutlet weak var urlTextView: UITextField!
    @IBOutlet weak var EmailBtn: UILabel!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        
        let provider = currentUser?.providerData
        
        for i in provider!{
            let providerfb = i.providerID
            switch providerfb {
            case "facebook.com":
                facebookCheck = true
                
                FBProvider()
            case "password"    :
                facebookCheck = false
                EmailProvider()
            default:
                print("Unknown provider ID: \(provider!)")
                return
            }
            
        }
        imageProfile.layer.cornerRadius = 50
        EditBtn.layer.borderColor = UIColor.green.cgColor
        EditBtn.layer.cornerRadius = 2;
        EditBtn.layer.borderWidth = 1;
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
    
    @IBAction func AccProviderBtn(_ sender: Any) {
        if EditBtn.tag == 0 {
            PresentAlertController(title: "FB Linked", message: "Your account link with FaceBook", actionTitle: "Ok")
            
            
        }else{
            performSegue(withIdentifier:"GotoEditProfile", sender: self)        }
    }
    func FBProvider(){
        if currentUser?.photoURL == nil {
            
        }else{
            
            let data = try? Data(contentsOf: (currentUser?.photoURL)!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                
                let newimag = UIComponentHelper.resizeImage(image: image!, targetSize: CGSize(width: 150, height: 100))
                imageProfile.setImage(newimag, for: .normal)
            }
            
            
        }
        userName.text =  currentUser?.displayName
        EmailBtn.text = currentUser?.email
        
        let facebookProvider = NSPredicate(format: "facebookProvider = 1")
        let fb_lgoin = personService.get(withPredicate: facebookProvider)
        EditBtn.setTitle("FBLinked", for: .normal)
        
        
        if (fb_lgoin != nil ){
            for i in fb_lgoin {
                let img = UIImage(data: i.imageData as! Data)
                let newimag = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 150, height: 100))
                imageProfile.setImage(newimag, for: .normal)
            }
            
        }
        
    }
    
    @IBAction func didTapTakePicture(_ sender: Any) {
        let imageUploadAlert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .actionSheet)
        
        imageUploadAlert.addAction(UIAlertAction(title:"Take Photo", style:.default,handler: { (action: UIAlertAction!) in
            self.TakePhoto()
        }))
        
        imageUploadAlert.addAction(UIAlertAction(title:"Select from Photo Library", style:.default,handler:{ (action: UIAlertAction!) in
            self.SelectPhotoFromLibrary()
        }))
        imageUploadAlert.addAction(UIAlertAction(title:"Cancel", style:.default,handler: nil))
        self.present(imageUploadAlert,animated: true)
    }
    
    func EmailProvider(){
        if currentUser?.photoURL == nil {
            
        }else{
            
            let data = try? Data(contentsOf: (currentUser?.photoURL)!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                
                let newimag = UIComponentHelper.resizeImage(image: image!, targetSize: CGSize(width: 150, height: 100))
                imageProfile.setImage(newimag, for: .normal)
            }
            
            
        }
        userName.text =  currentUser?.displayName
        EmailBtn.text = currentUser?.email
        
        let emailProvider = NSPredicate(format: "facebookProvider = 0")
        let email_lgoin = personService.get(withPredicate: emailProvider)
        if email_lgoin != nil{
            for i in email_lgoin {
                if i.imageData != nil{
                    print ("No image data save in core data")
                    
                }else{
                    // if user no internet still they can get imageProfile from coredata
                    let img = UIImage(data: i.imageData as! Data)
                    let newimag = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 150, height: 100))
                    imageProfile.setImage(newimag, for: .normal)
                    
                }
                
            }
            
        }
    
    }
    
    func TakePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true {
            
            self.imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
            
        }else{
            print("no wokr")
            
        }
        
    }
    func SelectPhotoFromLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) == true {
            
            self.imagePicker.sourceType = .photoLibrary
            
            
            self.present(imagePicker, animated: true)
            
            
        }else{
            print("No wokr")
        }
    }
    
    func deleteAllData(entity: String)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                try context.save()
                
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
    
    func inKirirom(){
        let smsAlert = UIAlertController(title: "EmergencySOS", message: "We will generate a SMS along with your current location to our supports. We suggest you not to move far away from your current position, as we're trying our best to get there as soon as possible. \n (Standard SMS rates may apply)", preferredStyle: UIAlertControllerStyle.alert)
        
        smsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.SMS()
        }))
        
        smsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(smsAlert, animated: true, completion: nil)
        
        
    }
    //send SMS
    func SMS(){
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
        
        contactusAlert.addAction(UIAlertAction(title:"English Speaker   010905998", style:.default,handler: { (action: UIAlertAction!) in
            guard let number = URL(string: "tel://" + "010905998" ) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
                       
           
        }))

        contactusAlert.addAction(UIAlertAction(title:"Ok", style:.default,handler: nil))
        self.present(contactusAlert,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage = info["UIImagePickerCOntrollerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let setectImage = selectedImageFromPicker{
           
            let newImage = UIComponentHelper.resizeImage(image: setectImage, targetSize: CGSize(width: 150, height: 100))
            
            let imageProfiles = UIImagePNGRepresentation( newImage)
            let riversRef = storageRef.child("Profile-image").child((currentUser?.displayName)!)
            
            let uploadTask = riversRef.putData(imageProfiles! , metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    self.PresentAlertController(title: "Something went wrong", message: "Can not upload to server. Please Check you internet connection ", actionTitle: "Got it")

                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL()!.absoluteString
                print(downloadURL)
                let url = NSURL(string: downloadURL) as? URL
                let chageProfileimage = self.currentUser?.createProfileChangeRequest()
                chageProfileimage?.photoURL =  url
                chageProfileimage?.commitChanges { (error) in
                    
                }
                self.imageProfile.setImage(setectImage, for: .normal)
                // if Facebook login Update Image
                
                if self.facebookCheck {
                    self.FBProviderUpdateImage(image: imageProfiles as! NSData)
                    
                }else{
                    self.EmailProviderUpdateImage(image: imageProfiles as! NSData)
                }
                
            }
            
            
        }
        dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    // update image to Core
    func EmailProviderUpdateImage(image: NSData){
        
        let emailProvider = NSPredicate(format: "facebookProvider = 0")
        let email_lgoin = personService.get(withPredicate: emailProvider)
        for i in email_lgoin {
            print("Email done")
            i.imageData = image
            personService.updateUserProfile(_updatedPerson: i)
            
        }
    }
    // update image to Core
    func FBProviderUpdateImage(image : NSData){
        let facebookProvider = NSPredicate(format: "facebookProvider = 1")
        let fb_lgoin = personService.get(withPredicate: facebookProvider)
        for i in fb_lgoin {
            print("facebook done")
            
            i.imageData = image
            
            personService.updateUserProfile(_updatedPerson: i)
            
        }
     
    }

}


