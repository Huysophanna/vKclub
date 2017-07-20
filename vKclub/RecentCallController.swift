//
//  RecentCallController.swift
//  vKclub
//
//  Created by HuySophanna on 13/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit
import CoreData


class RecentCallViewCell: UITableViewCell {
    @IBOutlet weak var callIndicatorIcon: UIImageView!
    @IBOutlet weak var callLogTimeLabel: UILabel!
    @IBOutlet weak var callerID: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
}


class RecentCallController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let callDataRequest: NSFetchRequest<SipCallData> = SipCallData.fetchRequest()
    static var callLogData = [SipCallData]()
    static var tableViewRef = UITableView()
    
    let (todayYear, todayMonth, todayDate, todayHour, todayMinute, todaySec) = UIComponentHelper.GetTodayString()
    var incomingCallInstance = IncomingCallController()
    var currentCallLogBtnHeight = 0;
    var callLogBtnColor = "#218154"
    var switchCallLogBtnColor = false {
        didSet {
            if switchCallLogBtnColor == true {
                callLogBtnColor = "#539C64"
            } else {
                callLogBtnColor = "#218154"
            }
        }
        
    }
    var callLogDataCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.delegate = self
        self.tableView.delegate = self
        RecentCallController.tableViewRef.delegate = self
        
        RecentCallController.LoadCallDataCell()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        //recent call tab is 1
        if tabBarIndex == 1 {
            print("RECENT CALL TAB ===")
        }
    }
    
    static func LoadCallDataCell() {
        do {
            callLogData = try manageObjectContext.fetch(callDataRequest)
            tableViewRef.reloadData()
            
            print(callLogData.count, "==COUNTINLOAD=")
        } catch {
            print("Could not get call data from CoreData \(error.localizedDescription) ===")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if RecentCallController.callLogData.count == 0 {
            return 1
        } else {
            return RecentCallController.callLogData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentCallCell = tableView.dequeueReusableCell(withIdentifier: "RecentCallTableView", for: indexPath) as! RecentCallViewCell
        
        //start index path from last index instead
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - (indexPath.row + 1)
        let reverseIndexPath = IndexPath(row: lastRow, section: 0)
        
        RecentCallController.tableViewRef = tableView
        
        //No call data yet
        if RecentCallController.callLogData.count == 0 {
            recentCallCell.callerID.textColor = UIColor(hexString: "#AAAAAA", alpha: 1)
            recentCallCell.callerID.text = "No call data"
            recentCallCell.callIndicatorIcon.image = UIImage(named: "outgoing-call-icon")
            recentCallCell.callIndicatorIcon.tintColor = UIColor(hexString: "#AAAAAA", alpha: 1)
            recentCallCell.timeStampLabel.text = ""
            recentCallCell.callLogTimeLabel.text = ""
        } else {
            //Loading call log data
            let callLogDataItem = RecentCallController.callLogData[reverseIndexPath.row]
            if callLogDataItem.callerID != nil {
                recentCallCell.callerID.textColor = UIColor.black
                recentCallCell.callerID.text = callLogDataItem.callerName != "" ? callLogDataItem.callerName : callLogDataItem.callerID
                recentCallCell.callIndicatorIcon.image = UIImage(named: callLogDataItem.callIndicatorIcon!)
                recentCallCell.callIndicatorIcon.tintColor = UIColor(hexString: "#008040", alpha: 1)
                
                recentCallCell.timeStampLabel.text = callLogDataItem.callDuration == "" ? callLogDataItem.callerID : "\(callLogDataItem.callerID!) (\(callLogDataItem.callDuration!) mn)"
                
                
                let _timeLogArray = callLogDataItem.callLogTime?.components(separatedBy: "-")
                //if the call log data date is today
                if todayYear == _timeLogArray?[0] && todayMonth == _timeLogArray?[1] && todayDate == _timeLogArray?[2] {
                    recentCallCell.callLogTimeLabel.text = (_timeLogArray?[3])! + ":" + (_timeLogArray?[4])!
                } else {
                    //if the call log data date is not today
                    recentCallCell.callLogTimeLabel.text = (_timeLogArray?[1])! + "/" + (_timeLogArray?[2])! + "/" + (_timeLogArray?[0])!
                }
                
            }
        }
        
        //Switch button color
        //        self.switchCallLogBtnColor = !self.switchCallLogBtnColor
        //        recentCallCell.backgroundColor = UIColor(hexString: callLogBtnColor, alpha: 1)
        
        return recentCallCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //start index path from last index instead
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - (indexPath.row + 1)
        let reverseIndexPath = IndexPath(row: lastRow, section: 0)
        
        //cellIndex for removing table view cell, reverseIndex for removing coredata value since we reversed data in view
        PresentActionSheet(_cellIndex: indexPath, _reverseIndex: reverseIndexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //start index path from last index instead
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - (indexPath.row + 1)
        let reverseIndexPath = IndexPath(row: lastRow, section: 0)
        
        //Handle delete cell
        if editingStyle == .delete {
            HandleDeleteCallTableCell(_cellIndex: indexPath, _reverseIndex: reverseIndexPath)
        }
        
    }
    
    func HandleDeleteCallTableCell(_cellIndex: IndexPath, _reverseIndex: IndexPath) {
        let callLogDataItem = RecentCallController.callLogData[_reverseIndex.row]
        RecentCallController.callLogData.remove(at: _reverseIndex.row)
        do {
            manageObjectContext.delete(callLogDataItem)
            try manageObjectContext.save()
        } catch {
            print("CAN\'T SAVE IN CELL DELETION \(error.localizedDescription)")
        }
        self.tableView.deleteRows(at: [_cellIndex], with: .automatic)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func PresentActionSheet(_cellIndex: IndexPath, _reverseIndex: IndexPath) {
        let callLogDataItem = RecentCallController.callLogData[_reverseIndex.row]
        
        let actionSheet = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        let dialBtnHandler = UIAlertAction(title: "Dial", style: .default, handler: {(action) -> Void in
            IncomingCallController.dialPhoneNumber = callLogDataItem.callerID!
            self.incomingCallInstance.callToFlag = true
            LinphoneManager.makeCall(phoneNumber: callLogDataItem.callerID!)
        })
        let cancelBtnHandler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(dialBtnHandler)
        actionSheet.addAction(cancelBtnHandler)
        actionSheet.addAction(UIAlertAction(title: "Test Delete All", style: .default, handler: {test in
            UserProfileCoreData.deleteAllData(entity: "SipCallData")
            print("Done delete ---")
        }))
        
        self.present(actionSheet, animated: true)
        
    }
    
}
