//
//  ShortcutSettings.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation
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
