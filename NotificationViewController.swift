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
    @IBOutlet weak var viewNotifictionBtn: UIButton!
    @IBOutlet weak var notification_title: UILabel!
    let personService = UserProfileCoreData()
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
        notification_num = 0
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
            for i in notifications{
                i.notification_num = 0
            }
            
            
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
        if notifications.count == 0 {
            ViewofClearnotification.isHidden = false
            Imgae.isHidden  = false
            text.isHidden   = false
        } else{
            ViewofClearnotification.isHidden = true
            Imgae.isHidden  = true
            text.isHidden   = true
            loadData()
        }
        
        return notifications.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell
        let notificationItem = notifications[indexPath.row]
        cell.notification_title.text = notificationItem.notification_title
        cell.notitfication_body.text = notificationItem.notification_body
        cell.viewNotifictionBtn.tag = indexPath.row
        cell.viewNotifictionBtn.addTarget(self, action: #selector(HandleViewNotification), for: .touchUpInside)
        return cell
    }
    func HandleDeleteNotificationTableCell(_cellIndex: IndexPath, _reverseIndex: IndexPath) {
        let callLogDataItem = notifications[_reverseIndex.row]
        notifications.remove(at: _reverseIndex.row)
        do {
            manageObjectContext.delete(callLogDataItem)
            try manageObjectContext.save()
        } catch {
            print("CAN\'T SAVE IN CELL DELETION \(error.localizedDescription)")
        }
        self.tableView.deleteRows(at: [_cellIndex], with: .automatic)
    }
    @IBAction func HandleViewNotification(sender : UIButton){
        let alertNotificationData = notifications[sender.tag]
        
        PresentAlertController(title: alertNotificationData.notification_title!, message: alertNotificationData.notification_body!, actionTitle: "Okay")
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - (indexPath.row + 1)
        let reverseIndexPath = IndexPath(row: lastRow, section: 0)
        //handle delete cell
        if editingStyle == .delete {
            HandleDeleteNotificationTableCell(_cellIndex: indexPath, _reverseIndex: reverseIndexPath)
            
        }
        
        
        
    }
  @IBAction func CancelBtn(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ClearNotification(_ sender: Any) {
        personService.deleteAllData(entity: "Notifications")
        ViewofClearnotification.isHidden = false
        Imgae.isHidden  = false
        text.isHidden   = false
        loadData()
        self.tableView.reloadData()
    }

}
