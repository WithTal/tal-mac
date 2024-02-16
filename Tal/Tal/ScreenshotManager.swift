//
//  ScreenshotManager.swift
//  Tal
//
//  Created by Pablo Hansen on 2/13/24.
//

import Foundation
import UniformTypeIdentifiers

import Foundation
import UniformTypeIdentifiers
import Vision
import Cocoa
import CoreGraphics

class ScreenshotManager {
    var timer: Timer?
    var isRunning = false
    var ocrQueue = DispatchQueue(label: "com.yourapp.ocrQueue")

    func startTakingScreenshots() {
        guard !isRunning else { return }

        // Set up a timer to take a screenshot every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
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

       // Perform OCR on the captured image
       ocrQueue.async { [weak self] in
           self?.performOCR(on: image)
       }
        guard let destinationUrl = getDestinationUrl() else { return }
        guard let destination = CGImageDestinationCreateWithURL(destinationUrl as CFURL, UTType.png.identifier as CFString, 1, nil) else { return }
        CGImageDestinationAddImage(destination, image, nil)
        CGImageDestinationFinalize(destination)

        // Log the file path
        print("Screenshot saved to: \(destinationUrl.path)")
    }
//    zzzzzzzzzzzzz
    
    
    private func performOCR(on image: CGImage) {
           let request = VNRecognizeTextRequest { request, error in
               guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                   print("OCR error: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }

               let recognizedStrings = observations.compactMap { observation in
                   observation.topCandidates(1).first?.string
               }.joined(separator: "\n")

               // Handle the recognized text as needed
               print("Recognized text: \(recognizedStrings)")
               // You can save this text, log it, or perform any other operation here
           }

           // Configure the request as needed, e.g., for fast or accurate recognition
           request.recognitionLevel = .accurate

           let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
           do {
               try requestHandler.perform([request])
           } catch {
               print("Failed to perform OCR: \(error.localizedDescription)")
           }
       }


    private func getDestinationUrl() -> URL? {
        // Define the destination URL for the screenshot
        let fileManager = FileManager.default
        let folderUrl = fileManager.urls(for: .picturesDirectory, in: .userDomainMask).first!
        let fileName = "screenshot_\(Date().timeIntervalSince1970).png"
        return folderUrl.appendingPathComponent(fileName)
    }
}
