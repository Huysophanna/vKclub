//
//  StudyHub+CoreDataProperties.swift
//  vKclub
//
//  Created by Machintos-HD on 7/1/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import Foundation
import CoreData


extension StudyHub {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyHub> {
        return NSFetchRequest<StudyHub>(entityName: "StudyHub")
    }

    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var image: String?

}
