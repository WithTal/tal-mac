//
//  ScreenshotManager.swift
//  Tal
//
//  Created by Pablo Hansen on 2/13/24.
//

import Foundation
import UniformTypeIdentifiers

import Cocoa
import CoreGraphics

class ScreenshotManager {
    var timer: Timer?
    var isRunning = false

    func startTakingScreenshots() {
        guard !isRunning else { return }

        // Request screen recording permission here if not already granted
        // Note: macOS requires explicit permission from the user to record the screen

        // Set up a timer to take a screenshot every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.takeScreenshot()
        }
        isRunning = true
    }

    func stopTakingScreenshots() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func takeScreenshot() {
        print("Taking screenshot")
        let displayID = CGMainDisplayID()
        let screenFrame = CGDisplayBounds(displayID)
        guard let image = CGWindowListCreateImage(screenFrame, .optionOnScreenOnly, kCGNullWindowID, .bestResolution) else { return }

        guard let destinationUrl = getDestinationUrl() else { return }
        guard let destination = CGImageDestinationCreateWithURL(destinationUrl as CFURL, UTType.png.identifier as CFString, 1, nil) else { return }
        CGImageDestinationAddImage(destination, image, nil)
        CGImageDestinationFinalize(destination)

        // Log the file path
        print("Screenshot saved to: \(destinationUrl.path)")
    }


    private func getDestinationUrl() -> URL? {
        // Define the destination URL for the screenshot
        let fileManager = FileManager.default
        let folderUrl = fileManager.urls(for: .picturesDirectory, in: .userDomainMask).first!
        let fileName = "screenshot_\(Date().timeIntervalSince1970).png"
        return folderUrl.appendingPathComponent(fileName)
    }
}
