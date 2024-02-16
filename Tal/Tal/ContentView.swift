//
//  ContentView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/13/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default)
    private var items: FetchedResults<Item>

    // Screenshot Manager
    private var screenshotManager = ScreenshotManager()

    // State to control screenshot taking
    @State private var isTakingScreenshots = false

    var body: some View {
        ScrollView {
            Button(action: toggleScreenshotTaking) {
                Text(isTakingScreenshots ? "Stop Screenshots" : "Start Screenshots")
            }
        }
    }
    private func toggleScreenshotTaking() {
        if isTakingScreenshots {
            // Stop taking screenshots
            screenshotManager.stopTakingScreenshots()
        } else {
            // Start taking screenshots
            screenshotManager.startTakingScreenshots()
        }
        isTakingScreenshots.toggle()
    }


 
    
    private func log(){
        for item in items{
            if let timestamp = item.timestamp {
                print("Item timestamp: \(timestamp)")
            } else {
                print("Item has no timestamp")
            }
        }
        
    }

}
