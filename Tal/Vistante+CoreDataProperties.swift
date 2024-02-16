//
//  Vistante+CoreDataProperties.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//
//

import Foundation
import CoreData


extension Vistante {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vistante> {
        return NSFetchRequest<Vistante>(entityName: "Vistante")
    }

    @NSManaged public var visitype: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?

}

extension Vistante : Identifiable {

}
