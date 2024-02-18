//
//  WebsiteView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/16/24.
//

import Foundation


import Foundation
import CoreData

class VistanteWebsiteViewModel: ObservableObject {
    @Published var visitantesToday: [Vistante] = []
    @Published var totalDurationsByDomain: [String: TimeInterval] = [:]
//    @Published var sortedDurations: [(domain: String, duration: TimeInterval)]
    
    
//    var sortedDurations: [(domain: String, duration: TimeInterval)] {
//            return         }

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchVistante()
    }

    func fetchVistante() {
        let request: NSFetchRequest<Vistante> = Vistante.fetchRequest()
        // Update sort descriptors to order the data by timestamp in descending order
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
//        request.fetchLimit = 50

        // Calculate the time one hour ago from the current time
        let oneHourAgo = Date().addingTimeInterval(-3600) // 3600 seconds = 1 hour

        // Set the predicate to fetch records from the last hour
        request.predicate = NSPredicate(format: "timestamp >= %@", oneHourAgo as NSDate)

        do {
            visitantesToday = try context.fetch(request)
            calculateTotalDurations()
//            sortedDurations = totalDurationsByDomain.sorted { $0.key < $1.key }
//                                                   .map { (domain: $0.key, duration: $0.value) }

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
        guard let urlString = urlString,
              let url = URL(string: urlString),
              let domain = url.host else {
            return "Unknown"
        }
        return domain
    }
}
