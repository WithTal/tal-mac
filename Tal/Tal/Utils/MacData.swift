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
    // Define a vibrant color palette
    let colors: [Color] = [
        Color(hue: 0.2, saturation: 0.5, brightness: 1.0), // Light Red
        Color(hue: 0.4, saturation: 0.5, brightness: 1.0), // Light Green
        Color(hue: 0.55, saturation: 0.5, brightness: 1.0), // Light Blue
        Color(hue: 0.12, saturation: 0.5, brightness: 1.0), // Light Yellow
        Color(hue: 0.75, saturation: 0.5, brightness: 1.0), // Light Purple
        Color(hue: 0.88, saturation: 0.5, brightness: 1.0), // Light Pink
        Color(hue: 0.08, saturation: 0.5, brightness: 1.0), // Light Orange
//        Color(hue: 0.0, saturation: 0.0, brightness: 0.8)   // Light Gray
    ]


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
