//
//  Time.swift
//  Tal
//
//  Created by Pablo Hansen on 2/17/24.
//

import Foundation

func formatDuration(_ duration: TimeInterval) -> String {
    // Format the duration as needed, e.g., into minutes and seconds
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    return formatter.string(from: duration) ?? "N/A"
}
