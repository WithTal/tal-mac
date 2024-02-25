//
//  Screenshot+CoreDataProperties.swift
//  Tal
//
//  Created by Pablo Hansen on 2/18/24.
//
//

import Foundation
import CoreData


extension Screenshot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Screenshot> {
        return NSFetchRequest<Screenshot>(entityName: "Screenshot")
    }

    @NSManaged public var filepath: String?
    @NSManaged public var timestamp: Date?

}

extension Screenshot : Identifiable {

}
