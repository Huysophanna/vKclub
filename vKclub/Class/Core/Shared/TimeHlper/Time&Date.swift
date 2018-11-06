//
//  Time&Date.swift
//  vKclub
//
//  Created by Machintos-HD on 7/17/18.
//  Copyright © 2018 WiAdvance. All rights reserved.
//

import Foundation

class TimeHlper {
    
    static func GetTodayString() -> (String, String, String, String, String, String) {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        var am_pm = ""
        let year = components.year
        let month = components.month! < 10 ? "0" + String(components.month!) : String(components.month!)
        let day = components.day! < 10 ? "0" + String(components.day!) : String(components.day!)
        var hour = components.hour! < 10 ? "0" + String(components.hour!) : String(components.hour!)
        
        if Int(hour)! > 12 {
            hour = String((Int(hour)!) - 12)
            am_pm = "PM"
        } else {
            am_pm = "AM"
        }
        
        let minute = components.minute! < 10 ? "0" + String(components.minute!) + am_pm : String(components.minute!) + am_pm
        let second = components.second! < 10 ? "0" + String(components.second!) : String(components.second!)
        
        return (String(year!), String(month), String(day), String(hour), String(minute), String(second))
    }
    
}
