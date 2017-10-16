import UIKit
import UserNotifications

class SettingController: UIViewController,UNUserNotificationCenterDelegate,UIApplicationDelegate {
    
    
    
    @IBOutlet weak var NotificationSetting: UISwitch!
   
    override func viewDidLoad() {
        super.viewDidLoad()
          Check()
        let cancelBtn: UIButton = UIButton (type: UIButtonType.custom)
        cancelBtn.setImage(UIImage(named: "Cancel"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(SettingController.cancelBtn), for: .touchUpInside)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: cancelBtn)
        let width = barButton.customView?.widthAnchor.constraint(equalToConstant: 20)
        width?.isActive = true
        let height = barButton.customView?.heightAnchor.constraint(equalToConstant: 20)
        height?.isActive = true
        self.navigationItem.leftBarButtonItem = barButton
       
        
        
       
        
    }
    func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)   
    }
    
    @IBAction func HelpBtn(_ sender: Any) {
        self.PresentAlertController(title: "Help", message: "Notification: Turn OFF/ON all incoming alert notification including Digital News Content as well as Chat Messaging.", actionTitle: "Okay")
        
    }
    
    func Check(){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            
            DispatchQueue.main.async(execute: {
                if(settings.authorizationStatus == .authorized){
                    self.NotificationSetting.isOn = true
                    if UIApplication.shared.isRegisteredForRemoteNotifications{
                        self.NotificationSetting.isOn = true
                        UserDefaults.standard.set(1, forKey: "setting")
                    }else{
                        self.NotificationSetting.isOn = false
                        UserDefaults.standard.set(2, forKey: "setting")
                    }
                    
                } else{
                    
                    self.NotificationSetting.isOn = false
                }
               
            })
            
        }
    }
   @IBAction func OnofOffNotification(_ sender: UISwitch) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized)
            {
              
                
                if sender.isOn{
                    self.NotificationSetting.isOn = true
                    UIApplication.shared.registerForRemoteNotifications()
                    self.Check()
                } else{
                    self.NotificationSetting.isOn = false
                    UIApplication.shared.unregisterForRemoteNotifications()
                    self.Check()
                    
                }

            }else{
                // OPEN Nottification user when you not allow notification
                let notificationPermissionAlert = UIAlertController(title: "Notifications disabled for vKclub App", message: "Please enable Notifications", preferredStyle: UIAlertControllerStyle.alert)
                
                notificationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                   UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
                }))
                notificationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (action: UIAlertAction!) in
                    self.NotificationSetting.isOn = false
                   
                }))
                self.present(notificationPermissionAlert, animated: true, completion: nil)
               
            }
        
        }

        
    }
    
    }
