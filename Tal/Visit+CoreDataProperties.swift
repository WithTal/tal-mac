//
//  Visit+CoreDataProperties.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//
//

import Foundation
import CoreData


extension Visit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
        return NSFetchRequest<Visit>(entityName: "Visit")
    }

    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?

}

extension Visit : Identifiable {

}
