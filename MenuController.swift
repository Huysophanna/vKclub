import UIKit

class MenuController: UIViewController {
   
    @IBOutlet weak var EmergencyBtn: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var EditBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
}
