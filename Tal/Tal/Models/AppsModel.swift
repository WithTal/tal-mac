//
//  AppsModel.swift
//  Tal
//
//  Created by Pablo Hansen on 2/20/24.
//

import AppKit
import SwiftUI
import CoreData
import Foundation
import CoreData


class AppsModel: ObservableObject {
    @Published var visitantes: [Vistante] = []
    @Published var durations: [TimeInterval] = []
    @Published var timeSpentPerApp: [String: TimeInterval] = [:] // New property

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchApps()
    }

    func fetchApps() {
        let request: NSFetchRequest<Vistante> = Vistante.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        // Calculate the time one hour ago from the current time
        let oneHourAgo = Date().addingTimeInterval(-3600)

        // Set the predicate to fetch records of type "app" from the last hour
        let typePredicate = NSPredicate(format: "visitype == %@", "app")
        let timePredicate = NSPredicate(format: "timestamp >= %@", oneHourAgo as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, timePredicate])

        do {
            visitantes = try context.fetch(request)
            calculateDurations()
        } catch {
            print("Error fetching data: \(error)")
        }
        
    }

    func calculateDurations() {
        durations = []
        timeSpentPerApp = [:] // Reset the dictionary

        for i in 0..<visitantes.count {
            if i < visitantes.count - 1,
               let currentTimestamp = visitantes[i].timestamp,
               let nextTimestamp = visitantes[i + 1].timestamp,
               let appName = visitantes[i].type {

                let duration = currentTimestamp.timeIntervalSince(nextTimestamp)
                durations.append(duration)

                timeSpentPerApp[appName, default: 0] += duration
            } else {
                durations.append(0)
            }
        }
    }

}



