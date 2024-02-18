//
//  MacData.swift
//  Tal
//
//  Created by Pablo Hansen on 2/16/24.
//

import Foundation
import AppKit
import SwiftUI

func iconForBundleIdentifier(_ bundleIdentifier: String) -> NSImage {
    if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) {
        return NSWorkspace.shared.icon(forFile: appURL.path)
    } else {
        return NSImage(systemSymbolName: "questionmark.app", accessibilityDescription: nil) ?? NSImage()
    }
}

func convertToCircleChartData(appDurations: [String: TimeInterval]) -> [CircleChartData] {
    let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .pink, .orange, .gray]
    var chartData: [CircleChartData] = []

    for (index, (app, duration)) in appDurations.enumerated() {
        if duration >= 5 {
            let color = colors[index % colors.count]
            let data = CircleChartData(value: CGFloat(duration), color: color, label: app)
            chartData.append(data)
        }
    }

    return chartData
}
