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
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: log) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Button(action: toggleScreenshotTaking) {
                        Text(isTakingScreenshots ? "Stop Screenshots" : "Start Screenshots")
                    }
                }

            }
            TabView {
                StoryView()
                    .tabItem {
                        Label("Home", systemImage: "person")
                    }
                StoryView()
                    .tabItem {
                        Label("Home", systemImage: "person")
                    }
                
            }

            Text("Select an item")
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


    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
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
    


    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
