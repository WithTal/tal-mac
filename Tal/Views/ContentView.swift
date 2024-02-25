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
    
    private var appMonitor = ApplicationController() // Add this line
    

    private var screenshotManager = ScreenshotController()

    let context = PersistenceController.shared.container.viewContext
    

    
    // State to control screenshot taking
    @State private var isTakingScreenshots = false
    @State private var timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()


    var body: some View {
//        VStack{
//            Image("Image") // Replace with your logo's image name
////                .resizable()
////                .aspectRatio(contentMode: .fit)
//                .frame(width: 200, height: 200) // Adj
//
            ZStack(alignment: .top) {
                ScrollView {
                    
                    VStack {
                        
//                        Button(action: PopperView.shared.showNotification) {
//                            Text("SHOW POPPER")
//
//                        }
//                        Button(action: PopperView.shared.showNotification) {
//                            Text("SHOW POPPER")
//
//                        }
//                        .padding(.top, 20)
//                        .zIndex(1)
//
//                        Button(action: PopperView.shared.hideNotification) {
//                            Text("HIDE POPPER")
//                        }
//                        .padding(.top, 20)
//                        .zIndex(1)
//                        Button(action: { PopperView.shared.changeLogoColor(to: .red) }) {
//
////                        Button(action: PopperView.shared.changeLogoColor(to: .red)) {
//                            Text("Change color")
//                        }
//                        .padding(.top, 20)
//                        .zIndex(1)
                        Spacer().frame(height: 60) // Space for the button, adjust as needed
                        
                        let appsChartData = convertToCircleChartData(appDurations: appsModel.timeSpentPerApp)
                        let websiteChartData = convertToCircleChartData(appDurations: websitesModel.totalDurationsByDomain)
                        
                        ConsumptionView(websitesData: websiteChartData, appsData: appsChartData)
                        LowerConsumptionView(viewModel: appsModel, websiteViewModel: websitesModel)
                    }
                    .padding([.leading, .trailing], 20)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 25/255, green: 25/255, blue: 25/255), Color(red: 10/255, green: 10/255, blue: 10/255)]), startPoint: .leading, endPoint: .trailing))
                
                //            .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667).opacity(1.0))
                .zIndex(0) // Ensures ScrollView is below the button
                
                
                Button(action: toggleScreenshotTaking) {
                    Text(isTakingScreenshots ? "Stop Screenshots" : "Start Screenshots")
        
                }
                .padding(.top, 20)
                .zIndex(1) // Ensures the button is above the ScrollView
                
               

                // Logo in the top left corner
                HStack {
                    Image("Image") // Replace with your logo's image name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50) // Adjust size as needed
                    Spacer()
                }
                .padding(.leading, 30)
                .padding(.trailing, 20)
                .padding(.top, 20)
                .zIndex(1) // Ensures the logo is above the ScrollView
                
                
                
//                .buttonStyle(FilledButton()) // Assuming you have a FilledButton style defined
//                .position(x: UIScreen.main.bounds.width / 2, y: 30) // Position your button, or use a different layout

            }
            .onReceive(timer) { _ in
                self.appsModel.fetchApps()
                self.websitesModel.fetchWebsites() // Assuming you have a similar method in WebsitesModel
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


