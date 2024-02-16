//
//  StorageSettings.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation
import SwiftUI


struct StorageSettingsView: View {
    @State private var selectedRetention: String = "Forever"
    let retentionOptions = ["Forever", "1 Year", "6 Months", "1 Month"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Disk Space Used: 1.5 GB (8 months)")
                .bold()
            
            Text("There are many factors that impact disk space usage including resolution, frame rate, redundancy, hours recorded, and retention period.")
            
            Button("Learn more...") {
                // Action for learn more
            }
            
            Divider()
            
            Text("Retention Period: How long do you want to keep recordings around?")
                .bold()
            
            Picker("Retention Period", selection: $selectedRetention) {
                ForEach(retentionOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Text("On average, Rewind uses 14 GB per month. If you reduce the retention period, you will save more space. This will also limit how far back you can search.")
            
            Button("Delete All Data...") {
                // Action for delete all data
            }
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(.red)
            
            Spacer() // Use spacer to push content to the top
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


