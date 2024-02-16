//
//  TalApp.swift
//  Tal
//
//  Created by Pablo Hansen on 2/13/24.
//

import SwiftUI

//@main
//struct TalApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}

@main
struct TalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        Settings {
            SettingsView()
        }
        
    }
}


