//
//  AppTracking.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation

import Cocoa

class ApplicationMonitor {
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
        // Here you can add logic to handle the active application
    }

    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
}
