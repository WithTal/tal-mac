//
//  SettingsView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

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
                .padding(20)
                .background(Color.black)
            PrivacySettingsView()
                .tabItem {
                    Label("Screen", systemImage: "desktopcomputer")
                }
                .tag(Tabs.advanced)
                .padding(20)
                .background(Color.black)
            StorageSettingsView()
                .tabItem {
                    Label("Storage", systemImage: "opticaldiscdrive")
                }
                .tag(Tabs.advanced)
                .padding(20)
                .background(Color.black)
            ShortcutsSettingsView()
                .tabItem {
                    Label("Shortcuts", systemImage: "keyboard")
                }
                .tag(Tabs.advanced)
                .padding(20)
                .background(Color.black)
        }
        
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



