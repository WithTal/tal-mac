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
    func enumerateAllApps() -> [String] {
        var appNames = [String]()

        let fileManager = FileManager.default
        // Directories to search for applications
        let appDirectories = [
            fileManager.urls(for: .applicationDirectory, in: .localDomainMask).first,
            fileManager.urls(for: .applicationDirectory, in: .systemDomainMask).first
        ].compactMap { $0 }

        for appsURL in appDirectories {
            if let enumerator = fileManager.enumerator(at: appsURL, includingPropertiesForKeys: nil, options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles]) {
                for case let element as URL in enumerator {
                    if element.pathExtension == "app" {
                        appNames.append(element.deletingPathExtension().lastPathComponent)
                    }
                }
            }
        }

        return appNames
    }

    

    

    private func takeScreenshot() {
        print("Taking screenshot")
        print("List of apps in app folder")
        print(enumerateAllApps())
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
    
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    private func performOCR(on image: CGImage) {
        let viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
           let request = VNRecognizeTextRequest { request, error in
               guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                   print("OCR error: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }

               let recognizedStrings = observations.compactMap { observation in
                   observation.topCandidates(1).first?.string
               }.joined(separator: "\n")

               
               // Regular expression pattern for URLs with or without schemes
               let urlPattern = "(https?://)?[a-zA-Z0-9.-]+\\.(com|net|org|edu|gov|mil|co|info|io|biz|us|uk|ca|au|de|fr|es|it|ru|jp|cn|in|[a-zA-Z]{2})(?:/[^\\s]*)?(?:\\b|\\s|$)"

//               let urlPattern = "(https?://)?[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}(?:/[^\\s]*)?"

               // Search for URL in the recognized text
               if let urlRange = recognizedStrings.range(of: urlPattern, options: .regularExpression),
                  let url = String(recognizedStrings[urlRange]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let validUrl = URL(string: "http://" + url) {
                   addVisit(name: String(url), type: "website", context: viewContext)
                   print("Extracted URL: \(validUrl)")
               } else {
                   print("No URL found in the text")
               }

               // ... [rest of the code]



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
