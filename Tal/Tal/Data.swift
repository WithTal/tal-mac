//
//  Data.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation
import CoreData

func addVisit(name: String, type: String, context: NSManagedObjectContext, bundleId: String? = nil) {
    
    
    let visit = Vistante(context: context)
    visit.timestamp = Date()
    visit.visitype = type
    visit.type = name
    visit.bundleId  = bundleId
    
    do {
        try context.save()
        print("Saved \(name)")
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
        }
    
    

    print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last ?? "Not Found")

    //    let newVisit = VisitEntry(context: context)
    //
    //    newVisit.name = name
    //    newVisit.timestamp = Date()
    //    newVisit.type = type
    //
    //    do {
    //        try context.save()
    //        print("Saved \(name)")
    //    } catch {
    //        // Handle the error appropriately
    //        print("Error saving context: \(error)")
    //    }
    //}
    
}
