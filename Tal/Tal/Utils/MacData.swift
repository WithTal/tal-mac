//
//  MacData.swift
//  Tal
//
//  Created by Pablo Hansen on 2/16/24.
//

import Foundation
import AppKit

func iconForBundleIdentifier(_ bundleIdentifier: String) -> NSImage {
    if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) {
        return NSWorkspace.shared.icon(forFile: appURL.path)
    } else {
        return NSImage(systemSymbolName: "questionmark.app", accessibilityDescription: nil) ?? NSImage()
    }
}

