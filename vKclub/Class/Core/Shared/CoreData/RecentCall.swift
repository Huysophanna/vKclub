//
//  RecentCall.swift
//  vKclub
//
//  Created by Machintos-HD on 9/25/18.
//  Copyright © 2018 WiAdvance. All rights reserved.
//

import Foundation
import CoreData


class RecentCall {
    static func StoreCallDataLog(_callerID: String , _callerName: String, _callDuration : String, _callIndicatorIcon: String) {
        
        let (year, month, date, hour, min, sec) = TimeHlper.GetTodayString()
        
        let timeStamp = "\(hour):\(min)"
        let callLogTime = "\(year)-\(month)-\(date)-\(hour)-\(min)-\(sec)"
        
        InComeCallController.callLogTime = callLogTime
        
        
        let CallDataLog = NSEntityDescription.insertNewObject(forEntityName: "SipCallData", into: managedObjectContext)
        
        CallDataLog.setValue(_callDuration, forKey: "callDuration")
        CallDataLog.setValue(_callerID, forKey: "callerID")
        CallDataLog.setValue(_callerName, forKey: "callerName")
        CallDataLog.setValue(_callIndicatorIcon, forKey: "callIndicatorIcon")
        CallDataLog.setValue(timeStamp, forKey: "timeStamp")
        CallDataLog.setValue(callLogTime, forKey: "callLogTime")
        
        
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Could not save CallDataLog into CoreData \(error.localizedDescription) ===")
        }
    }
    
}
