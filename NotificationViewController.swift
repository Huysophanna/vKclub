//
//  NotificationViewController.swift
//  vKclub
//
//  Created by Machintos-HD on 7/15/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit
import CoreData

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notitfication_body: UILabel!
    @IBOutlet weak var notification_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class NotificationViewController: UITableViewController {
    
    @IBOutlet weak var ViewofClearnotification: UIView!
    
    @IBOutlet weak var Imgae: UIImageView!
   
    @IBOutlet weak var text: UILabel!
    var notifications = [Notifications]()
    let personService = UserProfileCoreData()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func loadData(){
        let notificationRequest:NSFetchRequest<Notifications> = Notifications.fetchRequest()
        
        do {
             notifications = try manageObjectContext.fetch(notificationRequest)
            
             if notifications != [] {
                ViewofClearnotification.isHidden = true
                Imgae.isHidden  = true
                text.isHidden   = true
             }
            
            
             self.tableView.reloadData()
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell
        let notificationItem = notifications[indexPath.row]
        cell.notification_title.text = notificationItem.notification_title
        cell.notitfication_body.text = notificationItem.notification_body
        return cell
    }


    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
     Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
     Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
    }
    */
    @IBAction func CancelBtn(_ sender: Any) {
         dismiss(animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func ClearNotification(_ sender: Any) {
        personService.deleteAllData(entity: "Notifications")
        ViewofClearnotification.isHidden = false
        Imgae.isHidden  = false
        text.isHidden   = false
        self.tableView.reloadData()
        
        
       
    }
    

}
