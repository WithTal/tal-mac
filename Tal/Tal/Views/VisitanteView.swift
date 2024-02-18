//
//  VisitanteView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/16/24.
//

import Foundation
import AppKit
import SwiftUI
import CoreData

import Foundation
import CoreData

class VistanteViewModel: ObservableObject {
    @Published var visitantes: [Vistante] = []
    @Published var durations: [TimeInterval] = []

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
            visitantes = try context.fetch(request)
            calculateDurations()
        } catch {
            print("Error fetching data: \(error)")
        }
    }


    func calculateDurations() {
        durations = []
        for i in 0..<visitantes.count {
            if i < visitantes.count - 1,
               let currentTimestamp = visitantes[i].timestamp,
               let nextTimestamp = visitantes[i + 1].timestamp {
                let duration = currentTimestamp.timeIntervalSince(nextTimestamp)
                durations.append(duration)
            } else {
                // For the last item or if timestamp is nil, append 0 or a default value
                durations.append(0)
            }
        }
    }
}


struct VistanteGridView: View {
    @ObservedObject var viewModel: VistanteViewModel
    @ObservedObject var websiteViewModel: VistanteWebsiteViewModel
    
//    var sortedDurations: [(domain: String, duration: TimeInterval)] = VistanteWebsiteViewModel.totalDurationsByDomain.sorted { $0.key < $1.key }
//        .map { (domain: $0.key, duration: $0.value) }
    


    var body: some View {
        HStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Recent Consumption")
                    ForEach(Array(zip(viewModel.visitantes.indices, viewModel.visitantes)), id: \.0) { index, vistante in
                        HStack{
                            VStack(alignment: .leading) {
                                // Display the data from vistante
//                                Text(vistante.type ?? "Unknown Type")
                                if index < viewModel.durations.count {
//                                  Text("Duration: \((viewModel.durations[index]))")
                                    Text("\(formatDuration(viewModel.durations[index]))")
                                }
                                Image(nsImage: iconForBundleIdentifier(vistante.bundleId ?? "bundle"))
                                          .resizable()
                                          .aspectRatio(contentMode: .fit)
                                          .frame(width: 40, height: 40)
                           }
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 64, height: 64)
                            Divider()
                            Rectangle()
                                .fill(.green)
                                .frame(width: viewModel.durations[index]/60, height: 100)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer() // This pushes the VStack to the left
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Recent Consumption")
                    ForEach(Array(websiteViewModel.totalDurationsByDomain.keys), id: \.self) { value in
                        Text("\(value) : \(formatDuration(websiteViewModel.totalDurationsByDomain[value] ?? 9))")
                    }

//                    ForEach(websiteViewModel.visitantesToday) { visitantes in
//                        Text(visitantes.description)
//                    }
                }
            }
        }
        .padding()
    }
}


