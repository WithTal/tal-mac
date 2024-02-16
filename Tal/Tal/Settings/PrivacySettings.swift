//
//  PrivacySettings.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//
import Foundation
import SwiftUI
import KeyboardShortcuts

struct PrivacySettingsView: View {
    @State private var excludeApps: [String] = ["Activity Monitor", "AirPort Utility", "Anki", "App Store"]
    @State private var showRunningProcesses = false
    @State private var doNotRecordPrivateBrowsing = true
    @State private var textRecognitionSetting = "Standard"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Screen recordings are stored locally and not sent to the cloud.")
                .font(.headline)
            HStack {
                Image(systemName: "info.circle")
                Text("Note: These features have certain limitations.")
                    .foregroundColor(.gray)
                Button("Learn more...") {
                    // Action for learn more...
                }
                .buttonStyle(LinkButtonStyle())
            }
            
            Text("Exclude Apps: Select which apps you do not want recorded:")
                .font(.subheadline)
            
            List {
                ForEach(excludeApps, id: \.self) { app in
                    Text(app)
                }
            }
            .frame(height: 120)
            
            HStack {
                Button(action: {
                    // Action to show running processes...
                }) {
                    Label("Show Running Processes", systemImage: "plus")
                }
                
                Spacer()
                
                Toggle("Do not record Incognito and Private windows for Chrome, Safari, Arc and supported browsers...", isOn: $doNotRecordPrivateBrowsing)
            }
            
            Picker("Text Recognition:", selection: $textRecognitionSetting) {
                Text("Standard").tag("Standard")
                // Add other options here...
            }
            
            Spacer()
            
            Button(action: {
                // Action to delete all data...
            }) {
                Label("Delete All Data...", systemImage: "trash")
            }
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(.red)
        }
        .padding()
    }
}
