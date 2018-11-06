//
//  CoreDataInstance.swift
//  vKclub
//
//  Created by Machintos-HD on 7/17/18.
//  Copyright © 2018 WiAdvance. All rights reserved.
//

import Foundation
import CoreData

class SipCallCoreData {
    
    func getCallDataByID (_id: NSManagedObjectID) -> SipCallData? {
        return managedObjectContext.object(with: _id) as? SipCallData
    }
}
