//
//  SettingsView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation
import SwiftUI

import KeyboardShortcuts





// General
// - Account
// -
// Screen
// -
// Storage
// -
// Shortcuts
// -



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



func learnMore() {
    if let url = URL(string: "https://withtal.com") {
        NSWorkspace.shared.open(url)
    } else {
        print("Could not create URL")
    }
}

struct AccountSettingsView: View {
    @AppStorage("openAtLogin") private var openAtLogin = false
    @AppStorage("remindWhenPaused") private var remindWhenPaused = true
    @AppStorage("showInDock") private var showInDock = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Your trial expires in 26 days")
                
                    Button("Learn More...", action: learnMore)
                }
                Spacer()
                Button("Sign In") {
                    // Handle sign in action
                }
                .buttonStyle(.bordered)
            }
            Divider()
            Text("Account").bold()
            Toggle("Open Tal at login", isOn: $openAtLogin)
            Toggle("Remind me when Tal is paused", isOn: $remindWhenPaused)
            Toggle("Show in Dock", isOn: $showInDock)
        }
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}





struct AdvancedSettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0


    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
        }
        .padding(20)
    }
}
import SwiftUI

struct ShortcutsSettingsView: View {
    @State private var shortOpenTal = "⌘/"
    @State private var shortDailyRecap = "⌘;"
    @State private var shortFeedback = "⌘S"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            ShortcutKeyView(keyCombination: $shortOpenTal, label: "Open Tal:")
            ShortcutKeyView(keyCombination: $shortDailyRecap, label: "Daily Recap:")
            ShortcutKeyView(keyCombination: $shortFeedback, label: "Feedback:")


        }
        
    }
}

struct ShortcutKeyView: View {
    @Binding var keyCombination: String
    let label: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(keyCombination)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            Button("Restore Default") {
                // Handle restore default action
            }
        }
    }
}




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




struct KeyView: View {
    let key: String

    var body: some View {
        Text(key)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
    }
}



struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    
    
    var body: some View {
        TabView {
            AccountSettingsView()
                .tabItem {
                    Label("Account", systemImage: "gear")
                }
                .font(.headline)
                .tag(Tabs.general)
                .padding(.horizontal)
            PrivacySettingsView()
                .tabItem {
                    Label("Screen", systemImage: "desktopcomputer")
                }
                .tag(Tabs.advanced)
            StorageSettingsView()
                .tabItem {
                    Label("Storage", systemImage: "opticaldiscdrive")
                }
                .tag(Tabs.advanced)
            ShortcutsSettingsView()
                .tabItem {
                    Label("Shortcuts", systemImage: "keyboard")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
        
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        SettingsView()
            .preferredColorScheme(.dark) // If you want to preview with dark mode
            .previewDevice(PreviewDevice(rawValue: "Mac"))
    }
}
#endif



