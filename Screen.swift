import UIKit

struct Screen {
    
   
    static func  goToMainController() {
        let DashController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainDashboard") as! SWRevealViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = DashController
        
    }
    
    
}
