//
//  AppTracking.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation

import Cocoa
import CoreData

func addVisit(name: String, type: String, context: NSManagedObjectContext) {
    let visit = Vistante(context: context)
    visit.timestamp = Date()
    visit.visitype = type
    visit.type = name
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

class ApplicationMonitor {
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    init() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(self,
                                       selector: #selector(appDidActivate),
                                       name: NSWorkspace.didActivateApplicationNotification,
                                       object: nil)
    }

    @objc func appDidActivate(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let app = userInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              let appName = app.localizedName else {
            return
        }

        print("Activated app: \(appName)")
        addVisit(name: appName, type: "website", context: viewContext)
        // Here you can add logic to handle the active application
    }

    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
}
