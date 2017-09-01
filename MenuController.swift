import UIKit
import CoreData
import Firebase
import Photos
import MessageUI
import FBSDKLoginKit
class MenuController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate {
    var imagePicker : UIImagePickerController = UIImagePickerController()
    let personService = UserProfileCoreData()
    let Checklocation = DashboardController()
    let storageRef = Storage.storage().reference()
    let currentUser = Auth.auth().currentUser
    var loginControllerInstance: LoginController = LoginController()
    var facebookCheck : Bool = false
    @IBOutlet weak var EmergencyBtn: UIButton!
    @IBOutlet weak var imageProfile: UIButton!
    @IBOutlet weak var EmailBtn: UILabel!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        UserDefaults.standard.set(true, forKey: "loginBefore")
        
        if let provider = currentUser?.providerData {
            for i in provider {
                let providerfb = i.providerID
                switch providerfb {
                case "facebook.com":
                    facebookCheck = true
                    
                    FBProvider()
                case "password"    :
                    facebookCheck = false
                    EmailProvider()
                default:
                    print("Unknown provider ID: \(provider)")
                    return
                }
                
            }
        }
        
        
        
        //make responsive rounded user profile picture
        let checkDevice = UI_USER_INTERFACE_IDIOM()
        if checkDevice == .phone {
            imageProfile.frame = CGRect(x: EditBtn.frame.origin.x, y: imageProfile.bounds.width / 5, width: (view.bounds.width * 35) / 100, height: (view.bounds.width * 35) / 100)
            imageProfile.layer.cornerRadius = imageProfile.bounds.width / 2
            imageProfile.imageView?.contentMode = .scaleAspectFill
            imageProfile.contentHorizontalAlignment = .fill
            imageProfile.contentVerticalAlignment = .fill
        } else if checkDevice == .pad {
            imageProfile.frame = CGRect(x: EditBtn.frame.origin.x + (EditBtn.frame.origin.x / 6), y: imageProfile.bounds.width / 3, width: (view.bounds.width * 25) / 100, height: (view.bounds.width * 25) / 100)
            imageProfile.layer.cornerRadius = imageProfile.bounds.width / 2
            imageProfile.imageView?.contentMode = .scaleAspectFill
            imageProfile.contentHorizontalAlignment = .fill
            imageProfile.contentVerticalAlignment = .fill
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout(_ sender: Any) {
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            LinphoneManager.shutdown()
            InternetConnection.Logouts()
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present( logoutAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func AccProviderBtn(_ sender: Any) {
        if EditBtn.tag == 0 {
            PresentAlertController(title: "FB Linked", message: "You are currently linked your profile with Facebook account.", actionTitle: "Okay")
        } else {
            performSegue(withIdentifier:"GotoEditProfile", sender: self)        }
    }
    
    func FBProvider() {
        userName.text =  currentUser?.displayName
        EmailBtn.text = currentUser?.email
        let facebookProvider = NSPredicate(format: "facebookProvider = 1")
        let fb_lgoin = personService.getUserProfile(withPredicate: facebookProvider)
        EditBtn.setTitle("FBLinked", for: .normal)
        if fb_lgoin == [] {
            if currentUser?.email == nil {
                EmailBtn.text = "someone@gmail.com"

            }
            if currentUser?.photoURL == nil {
            } else {
                imageProfile.loadingIndicator(true)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    var  getFBimageUrl : URL = (self.currentUser?.photoURL)!
                    let str = self.currentUser?.photoURL?.absoluteString
                    let index = str?.index((str?.startIndex)!, offsetBy: 30)
                    let url : String = (str?.substring(to: index!))!
                    let fbphotourl:String = "https://scontent.xx.fbcdn.net/"
                    if url == fbphotourl {
                        let urlphoto: String = "https://graph.facebook.com/"
                        let picturelink:String = "/picture?width=320&height=320"
                        let FBImageUrl : String = urlphoto+FBSDKAccessToken.current().userID+picturelink
                        getFBimageUrl = URL(string:FBImageUrl)!
                    }
                    let data = try? Data(contentsOf: (getFBimageUrl))
                    
                    // When from background thread, UI needs to be updated on main_queue
                    DispatchQueue.main.async {
                        if data != nil {
                            self.imageProfile.loadingIndicator(false)
                            let image = UIImage(data: data!)
                            self.imageProfile.setImage(image, for: .normal)
                        }
    
                    }
                }
            }
        } else {
            for i in fb_lgoin {
                EmailBtn.text = i.email
                // if user no internet still they can get imageProfile from coredata
                let img = UIImage(data: i.imageData! as Data)
                let newimag = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 400, height: 400))
                imageProfile.setImage(newimag, for: .normal)
                
            }
            
        }
    }
    
    @IBAction func didTapTakePicture(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Upload Profile Picture", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.TakePhoto()

        })
        
        let deleteAction = UIAlertAction(title: "Select from Photo Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.SelectPhotoFromLibrary()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func EmailProvider(){
        EditBtn.tag = 1
        EmailBtn.text = currentUser?.email
        let emailProvider = NSPredicate(format: "facebookProvider = 0")
        let email_lgoin = personService.getUserProfile(withPredicate: emailProvider)
        
        if email_lgoin == [] {
            if currentUser?.photoURL == nil{
                imageProfile.loadingIndicator(true)
                
            }
            imageProfile.loadingIndicator(true)
                        userName.text =  currentUser?.displayName
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: (self.currentUser?.photoURL)!)
                        // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    if data != nil {
                        self.imageProfile.loadingIndicator(false)
                        let image = UIImage(data: data!)
                        
                        self.imageProfile.setImage(image, for: .normal)
                    }
                }
            }
            
        } else {
            
            for i in email_lgoin {
                userName.text = i.username
                let img = UIImage(data: i.imageData! as Data)
                // if user no internet still they can get imageProfile from coredata
                if img == nil {
                    self.imageProfile.loadingIndicator(false)
                    
                }else{
                   
                    let newimag = UIComponentHelper.resizeImage(image: img!, targetSize: CGSize(width: 400, height: 400))
                    imageProfile.setImage(newimag, for: .normal)
                }
              
            }
            
        }
  }
    
    func TakePhoto(){
        if InternetConnection.isConnectedToNetwork() {
            print("have internet")
        } else{
            self.PresentAlertController(title: "Something went wrong", message: "Can not upload to server. Please Check you internet connection ", actionTitle: "Got it")
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true {
            if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
                // Already Authorized
            } else {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        // User granted
                    } else {
                        let LocationPermissionAlert = UIAlertController(title: "Camera disabled for vKclub App", message: "Please enable your Camera by Clicking Okay", preferredStyle: UIAlertControllerStyle.alert)
                        
                        LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                           
                            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)                                
                        }))
                        LocationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
                        self.present( LocationPermissionAlert, animated: true, completion: nil)
                        
                    }
                })
            }
            self.imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        } else {
            print("no work")
            
        }
        
    }
    
    func SelectPhotoFromLibrary(){
        if InternetConnection.isConnectedToNetwork() {
            print("have internet")
        } else {
            self.PresentAlertController(title: "Something went wrong", message: "Can not upload to server. Please Check you internet connection ", actionTitle: "Got it")
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) == true {
            self.imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        } else {
            print("NO")
           
        }
    }
    
    @IBAction func EmergencySOS(_ sender: Any){
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            self.PresentAlertController(title: "Warning", message: "Your device doesn't support with this feature ", actionTitle: "Got it")
            
            return
        }
        let Check : String =  Checklocation.CheckUserLocation()
        if Check == "inKirirom" {
            self.inKirirom()
            
        } else if (Check == "offKirirom") {
            PresentAlertController(title: "Off-Kirirom mode", message: "Emergency SOS & Free internal   phone call features are not accessible for Off-Kirirom users.", actionTitle: "Got it")
        } else if( Check == "identifying"){
            UIComponentHelper.LocationPermission(INAPP_UNIDENTIFIEDSetting: false)
        } else {
            UIComponentHelper.LocationPermission(INAPP_UNIDENTIFIEDSetting: true)
        }
        
    }
    
    func inKirirom(){
        let smsAlert = UIAlertController(title: "EmergencySOS", message: "We will generate a SMS along with your current location to our supports. We suggest you not to move far away from your current position, as we're trying our best to get there as soon as possible. \n (Standard SMS rates may apply)", preferredStyle: UIAlertControllerStyle.alert)
        
        smsAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
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
        
        let alertController = UIAlertController(title: nil, message: "Contact us", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "English Speaker: (+855) 78 777 284", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                self.PresentAlertController(title: "Something went wrong", message: "Your device doesn't support with this feature ", actionTitle: "Got it")
                
                return
            }
            guard let number = URL(string: "tel://" + "078777284" ) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
            
        })
        
        let deleteAction = UIAlertAction(title: "Khmer Speaker: (+855) 96 2222 735", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                self.PresentAlertController(title: "Something went wrong", message: "Your device doesn't support with this feature ", actionTitle: "Got it")
                
                return
            }
            guard let number = URL(string: "tel://" + "0962222735" ) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        alertController.addAction(defaultAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //show image button loading indicator when changing profile picture
        imageProfile.loadingIndicator(true)
        
        var selectedImageFromPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
            }
        if let setectImage = selectedImageFromPicker{
            
            let newImage = UIComponentHelper.resizeImage(image: setectImage, targetSize: CGSize(width: 400, height: 400))
            let imageProfiles = UIImagePNGRepresentation(newImage)
            let imageData : NSData = NSData(data: imageProfiles!)
            let imageSize :Int = imageData.length
            if Double(imageSize) > 5000{
                self.PresentAlertController(title: "Something went wrong", message: "", actionTitle: "Got it")
            }
            print(Double(imageSize) / 1024.0,"++imagesize")
            let riversRef = storageRef.child("userprofile-photo").child((currentUser?.uid)!)
            riversRef.putData(imageProfiles! , metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    self.PresentAlertController(title: "Error", message: "please check with your internet connection", actionTitle: "Okay")
                        return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL()!.absoluteString
                print(downloadURL,"++++")
                print(downloadURL)
                let url = NSURL(string: downloadURL) as URL?
                let chageProfileimage = self.currentUser?.createProfileChangeRequest()
                chageProfileimage?.photoURL =  url
                chageProfileimage?.commitChanges { (error) in
                    self.PresentAlertController(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Okay")
                    return
                
                }
                
                //dismiss image button loading indicator when done
                self.imageProfile.loadingIndicator(false)
                
                self.imageProfile.setImage(setectImage, for: .normal)
                // if Facebook login Update Image
                if self.facebookCheck {
                    self.FBProviderUpdateImage(image: imageProfiles! as NSData)
                    
                } else {
                    self.EmailProviderUpdateImage(image: imageProfiles! as NSData)
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
        let email_lgoin = personService.getUserProfile(withPredicate: emailProvider)
        for i in email_lgoin {
            i.imageData = image
            personService.updateUserProfile(_updatedPerson: i)
            
        }
    }
    
    // update image to Core
    func FBProviderUpdateImage(image : NSData){
        let facebookProvider = NSPredicate(format: "facebookProvider = 1")
        let fb_lgoin = personService.getUserProfile(withPredicate: facebookProvider)
        for i in fb_lgoin {
            i.imageData = image
            personService.updateUserProfile(_updatedPerson: i)
            
        }
     
    }
    
}


