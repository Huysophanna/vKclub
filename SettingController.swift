import UIKit
import UserNotifications

class SettingController: UIViewController,UNUserNotificationCenterDelegate {
    
    
    @IBOutlet weak var NotificationSetting: UISwitch!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Check()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
               // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)   
    }
    
    func Check(){
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized){
                if UIApplication.shared.isRegisteredForRemoteNotifications{
                    self.NotificationSetting.isOn = true
                }else{
                    self.NotificationSetting.isOn = false
                }
                
            } else{
                
               self.NotificationSetting.isOn = false
           }
        }
    }
        

    
   
    
    @IBAction func OnofOffNotification(_ sender: UISwitch) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized)
            {
                if sender.isOn{
                    
                    UIApplication.shared.registerForRemoteNotifications()
                } else{
                    
                    UIApplication.shared.unregisterForRemoteNotifications()
                    
                }

            }else{
                let notificationPermissionAlert = UIAlertController(title: "Notifications disabled for vKclub App", message: "Please enable Notifications in Settings -> Notifications -> vKclub", preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                notificationPermissionAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.NotificationSetting.isOn = false

                }))

                self.present(notificationPermissionAlert, animated: true, completion: nil)
            }
        
        }

        
    }

}
