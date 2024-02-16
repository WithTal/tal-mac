//
//  AccountSettings.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation
import SwiftUI

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
