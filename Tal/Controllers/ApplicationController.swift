//
//  ApplicationController.swift
//  Tal
//
//  Created by Pablo Hansen on 2/20/24.
//

import Foundation
import Cocoa
import CoreData

class ApplicationController {
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
        
        let bundleIdentifier = app.bundleIdentifier
    
//        print("hbundle app: \(bundleIdentifier)")
        addVisit(name: appName, type: "app", context: viewContext, bundleId: bundleIdentifier)
        
        if appName != "Google Chrome"{
            addVisit(name: "None", type: "website", context: viewContext)
        }
        // Here you can add logic to handle the active application
    }

    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
}
