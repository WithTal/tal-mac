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
        // Vibrant Red
        Color(red: 0xE3 / 255, green: 0x4A / 255, blue: 0x36 / 255),
        // Bright Blue
        Color(red: 0x33 / 255, green: 0xB8 / 255, blue: 0xF9 / 255),
        // Soft Green (less vibrant)
        Color(red: 0x50 / 255, green: 0xC8 / 255, blue: 0x88 / 255),

        // Vivid colors using Hue, Saturation, Brightness model
        Color(hue: 0.0, saturation: 0.8, brightness: 1.0),  // Vivid Red
        Color(hue: 0.15, saturation: 0.8, brightness: 1.0), // Warm Yellow
        Color(hue: 0.55, saturation: 0.8, brightness: 1.0), // Vivid Blue
        Color(hue: 0.7, saturation: 0.8, brightness: 1.0),  // Vivid Cyan
        Color(hue: 0.8, saturation: 0.8, brightness: 1.0),  // Vivid Purple
        Color(hue: 0.05, saturation: 0.8, brightness: 1.0), // Vivid Orange
    ]


    var chartData: [CircleChartData] = []

    // Sort the app durations by descending order and take the first 8
    let sortedAppDurations = appDurations.sorted { $0.value > $1.value }.prefix(8)

    for (index, (app, duration)) in sortedAppDurations.enumerated() {
        if duration >= 5 {
            let color = colors[index % colors.count]
            let data = CircleChartData(value: CGFloat(duration), color: color, label: app)
            chartData.append(data)
        }
    }

    return chartData
}




func addVisit(name: String, type: String, context: NSManagedObjectContext, bundleId: String? = nil, timestamp: Date? = nil) {
    let visit = Vistante(context: context)
    
    // Use the provided timestamp if available; otherwise, use the current time
    visit.timestamp = timestamp ?? Date()
    visit.visitype = type
    visit.type = name
    visit.bundleId = bundleId
//    print(visit)
    
    do {
        try context.save()
        print("Saved \(name)")
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
        }
    
    
}
