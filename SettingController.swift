import UIKit

class SettingController: UIViewController {
    override func viewDidLoad() {   
        super.viewDidLoad()      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)   
    }  
}
