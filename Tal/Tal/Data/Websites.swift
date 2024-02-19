//
//  WebsiteView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/16/24.
//

import Foundation


import Foundation
import CoreData

class WebsitesModel: ObservableObject {
    @Published var visitantesToday: [Vistante] = []
    @Published var totalDurationsByDomain: [String: TimeInterval] = [:]

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchWebsites()
    }

    func fetchWebsites() {
        let request: NSFetchRequest<Vistante> = Vistante.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        // Calculate the time one hour ago from the current time
        let oneHourAgo = Date().addingTimeInterval(-800000) // 3600 seconds = 1 hour

        // Create predicates
        let timePredicate = NSPredicate(format: "timestamp >= %@", oneHourAgo as NSDate)
        let typePredicate = NSPredicate(format: "visitype == %@", "website") // Filter for type "website"

        // Combine predicates
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, timePredicate])

        do {
            visitantesToday = try context.fetch(request)
            print("V")
            print(visitantesToday)
            print("K")
            calculateTotalDurations()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func calculateTotalDurations() {
        totalDurationsByDomain = [:]
        var lastTimestamp: Date?

        for visitante in visitantesToday {
            let domain = extractDomain(from: visitante.type)
            if let currentTimestamp = visitante.timestamp {
                if let lastTime = lastTimestamp {
                    let duration = lastTime.timeIntervalSince(currentTimestamp)
                    totalDurationsByDomain[domain, default: 0] += duration
                }
                lastTimestamp = currentTimestamp
            }
        }
    }

    func extractDomain(from urlString: String?) -> String {
        guard let urlString = urlString else {
            print("URL string is nil")
            return "Unknown"
        }

        var formattedURLString = urlString

        // Check if the URL string contains a scheme. If not, prepend "http://".
        if !formattedURLString.contains("://") {
            formattedURLString = "http://" + formattedURLString
        }

        guard let url = URL(string: formattedURLString), let domain = url.host else {
            print("Invalid URL: \(formattedURLString)")
            return "Unknown"
        }

        return domain
    }
}
