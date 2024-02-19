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
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    Spacer().frame(height: 60) // Space for the button, adjust as needed

                    let appsChartData = convertToCircleChartData(appDurations: appsModel.timeSpentPerApp)
                    let websiteChartData = convertToCircleChartData(appDurations: websitesModel.totalDurationsByDomain)

                    ExperimentalView(websitesData: websiteChartData, appsData: appsChartData)
                    VistanteGridView(viewModel: appsModel, websiteViewModel: websitesModel)
                }
                .padding([.leading, .trailing], 20)
            }
            .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667).opacity(1.0))
            .zIndex(0) // Ensures ScrollView is below the button

            Button(action: toggleScreenshotTaking) {
                Text(isTakingScreenshots ? "Stop Screenshots" : "Start Screenshots")
            }
            .padding(.top, 20)
//            .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667))
            .zIndex(1) // Ensures the button layer is above the ScrollView
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
 
    
}


