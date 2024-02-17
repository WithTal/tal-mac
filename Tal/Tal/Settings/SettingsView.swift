//
//  SettingsView.swift
//  :
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation
import SwiftUI
import KeyboardShortcuts



struct SettingsView: View {
    @State private var selectedTab: Tabs = .general
    private enum Tabs: Hashable {
        case general, advanced
    }
    

    var body: some View {
        TabView {
            AccountSettingsView()
                .tabItem {
                    Label("Account", systemImage: "gear")

                        .foregroundColor(selectedTab == .general ? Color(red: 0.4745, green: 0.2784, blue: 0.8941) : Color.gray)

//                        .foregroundColor(Color(red: 0.4745, green: 0.2784, blue: 0.8941))

                }
                .tag(Tabs.general)
                .padding(20)
            
                .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667))
            PrivacySettingsView()
                .tabItem {
                    Label("Screen", systemImage: "desktopcomputer")
                }
                .tag(Tabs.advanced)
                .padding(20)
                .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667))
            StorageSettingsView()
                .tabItem {
                    Label("Storage", systemImage: "opticaldiscdrive")
                }
                .tag(Tabs.advanced)
                .padding(20)
                .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667))
            ShortcutsSettingsView()
                .tabItem {
                    Label("Shortcuts", systemImage: "keyboard")
                }
                .tag(Tabs.advanced)
                .padding(20)
                .background(Color(red: 0.0627, green: 0.0627, blue: 0.0667))
        }
        .toolbarBackground(

                // 1
//            40, 54, 24
            Color(red: 0.1020, green: 0.1137, blue: 0.1373)

//            Color(red: 0.1569, green: 0.2118, blue: 0.0941)

                // 2
        
        )
        
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

