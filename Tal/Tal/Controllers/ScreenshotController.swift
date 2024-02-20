//
//  ScreenshotController.swift
//  Tal
//
//  Created by Pablo Hansen on 2/20/24.
//

import Foundation
import UniformTypeIdentifiers

import Foundation
import UniformTypeIdentifiers
import Vision
import Cocoa
import CoreGraphics
import Accelerate

class ScreenshotController {
    
    
    var timer: Timer?
    var isRunning = false
    var ocrQueue = DispatchQueue(label: "com.yourapp.ocrQueue")

    func startTakingScreenshots() {
        guard !isRunning else { return }

        // Set up a timer to take a screenshot every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            
            self?.checkAndLogMissingVisit()
            self?.takeScreenshot()
//            print(self?.fetchLastScreenshotTime())
        }
        isRunning = true
    }
    
    func checkAndLogMissingVisit() {
        guard let lastScreenshotTime = fetchLastScreenshotTime() else { return }

        let currentTime = Date()
        let timeSinceLastScreenshot = currentTime.timeIntervalSince(lastScreenshotTime)

        if timeSinceLastScreenshot > 20 {
            let missingVisitTime = lastScreenshotTime.addingTimeInterval(20)
            logVisitNone(at: missingVisitTime)
        }
    }

    private func logVisitNone(at timestamp: Date) {
//        let newVisit = Visit(context: viewContext) // Assuming Visit is your Core Data entity
//        newVisit.timestamp = timestamp
//        newVisit.value = "none"
        addVisit(name: "None", type: "website", context: viewContext, timestamp: timestamp)
        addVisit(name: "None", type: "app", context: viewContext, timestamp: timestamp)

        do {
            try viewContext.save()
            print("Logged a visit with 'none' 20 seconds after last screenshot.")
        } catch {
            print("Failed to log 'none' visit: \(error)")
        }
    }
     
    
    func fetchLastScreenshotTime() -> Date? {
            let fetchRequest: NSFetchRequest<Screenshot> = Screenshot.fetchRequest()
            
            // Sort the fetch request so the most recent screenshot is first
            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // We only need the most recent screenshot
            fetchRequest.fetchLimit = 1

            do {
                let results = try viewContext.fetch(fetchRequest)
                return results.first?.timestamp
            } catch {
                print("Error fetching last screenshot time: \(error)")
                return nil
            }
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

    
    private func resizeImage(_ image: CGImage, toWidth width: Int, andHeight height: Int) -> CGImage? {
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer { sourceBuffer.data.deallocate() }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, image, vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }

        let destWidth = width
        let destHeight = height
        let bytesPerPixel = image.bitsPerPixel / image.bitsPerComponent
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer { destData.deallocate() }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight),
                                       width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)

        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, vImage_Flags(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }

        let resizedImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, vImage_Flags(kvImageNoFlags), &error)
        return resizedImage?.takeRetainedValue()
    }
    
    private func takeScreenshot() {
        let displayID = CGMainDisplayID()
        let screenFrame = CGDisplayBounds(displayID)
        guard let image = CGWindowListCreateImage(screenFrame, .optionOnScreenOnly, kCGNullWindowID, .bestResolution) else { return }

        // Your OCR operation remains unchanged
        ocrQueue.async { [weak self] in
            self?.performOCR(on: image)
        }
        
        let resizedWidth = 980
        let resizedHeight = 632
        guard let resizedImage = resizeImage(image, toWidth: resizedWidth, andHeight: resizedHeight) else { return }

        let timestamp = Date()

        guard let destinationUrl = getDestinationUrl() else { return }
        let jpgDestinationUrl = destinationUrl.deletingPathExtension().appendingPathExtension("jpg")
        guard let destination = CGImageDestinationCreateWithURL(jpgDestinationUrl as CFURL, UTType.jpeg.identifier as CFString, 1, nil) else { return }
        
        // Compression Quality Option
        let options: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: 0.7] // Adjust the compression quality (0.0 to 1.0)
        CGImageDestinationAddImage(destination, resizedImage, options as CFDictionary) // Use resizedImage here
        CGImageDestinationFinalize(destination)

        // Log the file path
        let newScreenshot = Screenshot(context: viewContext)
        newScreenshot.timestamp = timestamp
        newScreenshot.filepath = jpgDestinationUrl.path
        do {
            try viewContext.save()
            print("Screenshot info saved: \(jpgDestinationUrl.path)")
        } catch {
            print("Failed to save screenshot info: \(error)")
        }
    }

    
//    private func takeScreenshot() {
////        print("Taking screenshot")
////        print("List of apps in app folder")
////        print(enumerateAllApps())
//        let displayID = CGMainDisplayID()
//        let screenFrame = CGDisplayBounds(displayID)
//        guard let image = CGWindowListCreateImage(screenFrame, .optionOnScreenOnly, kCGNullWindowID, .bestResolution) else { return }
//
//       // Perform OCR on the captured image
//       ocrQueue.async { [weak self] in
//           self?.performOCR(on: image)
//       }
//
//        let timestamp = Date()
//
//        guard let destinationUrl = getDestinationUrl() else { return }
//        guard let destination = CGImageDestinationCreateWithURL(destinationUrl as CFURL, UTType.png.identifier as CFString, 1, nil) else { return }
//        CGImageDestinationAddImage(destination, image, nil)
//        CGImageDestinationFinalize(destination)
//
//        // Log the file path
//        let newScreenshot = Screenshot(context: viewContext)
//        newScreenshot.timestamp = timestamp
//        newScreenshot.filepath = destinationUrl.path
//        do {
//            try viewContext.save()
//            print("Screenshot info saved: \(destinationUrl.path)")
//        } catch {
//            print("Failed to save screenshot info: \(error)")
//        }
//    }
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
               
               if recognizedStrings.contains("ycombinator.com") {
                   DispatchQueue.main.async {
                       PopperView.shared.showNotification()
                   }
               }
               
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
