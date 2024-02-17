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
//    @State private var excludeApps: [String] = ["Activity Monitor", "AirPort Utility", "Anki", "App Store"]
    @State private var showRunningProcesses = false
    @State private var doNotRecordPrivateBrowsing = true
    @State private var textRecognitionSetting = "Standard"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Screen recordings never leave your device.")
                .font(.headline)
//                .fixedSize(horizontal: false, vertical: true)
            VStack{
            
                HStack {
                Image(systemName: "info.circle")
                Text("Note: These features have certain limitations.")
                    .foregroundColor(.gray)
                
            }
            
            }
            .buttonStyle(LinkButtonStyle())
            Text("Exclude Apps: Select which apps you do not want recorded:")
                .font(.subheadline)
            
//            List {
//                ForEach(excludeApps, id: \.self) { app in
//                    Text(app)
//                }
//            }
            
            
                
                Toggle("Do not record Incognito and Private windows on Browsers", isOn: $doNotRecordPrivateBrowsing)
            
            
            Picker("Text Recognition:", selection: $textRecognitionSetting) {
                Text("Standard").tag("Standard")
                Text("Other").tag("Other")
            }
            
            
            
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
