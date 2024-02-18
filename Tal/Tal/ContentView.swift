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
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default)
//    private var items: FetchedResults<Item>
    @ObservedObject var appsModel = AppsModel(context: PersistenceController.shared.container.viewContext)
    @ObservedObject var websitesModel = WebsitesModel(context: PersistenceController.shared.container.viewContext)


    // Screenshot Manager
    
    private var appMonitor = ApplicationMonitor() // Add this line
    

    private var screenshotManager = ScreenshotManager()

    let context = PersistenceController.shared.container.viewContext
    

    
    // State to control screenshot taking
    @State private var isTakingScreenshots = false

    var body: some View {
        ScrollView {
            Button(action: toggleScreenshotTaking) {
                Text(isTakingScreenshots ? "Stop Screenshots" : "Start Screenshots")
            }
            
            let appsChartData = convertToCircleChartData(appDurations: appsModel.timeSpentPerApp)
            
            let websiteChartData = convertToCircleChartData(appDurations: websitesModel.totalDurationsByDomain)
            
        
            ExperimentalView(websitesData: websiteChartData, appsData: appsChartData)

//            ExperimentalView()
            VistanteGridView(viewModel: appsModel, websiteViewModel:websitesModel)
        }
        .padding([.top, .leading, .trailing], 20)
        .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667))
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
 
    
}


