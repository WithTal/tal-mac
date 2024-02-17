//
//  VisitanteView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/16/24.
//

import Foundation

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
        // Add sort descriptors to ensure the data is ordered by timestamp
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]

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
                let duration = nextTimestamp.timeIntervalSince(currentTimestamp)
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

    var body: some View {
        HStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(Array(zip(viewModel.visitantes.indices, viewModel.visitantes)), id: \.0) { index, vistante in
                        HStack{
                            VStack(alignment: .leading) {
                                // Display the data from vistante
                                Text(vistante.type ?? "Unknown Type")
                                if index < viewModel.durations.count {
//                                    Text("Duration: \((viewModel.durations[index]))")
                                    Text("Duration: \(formatDuration(viewModel.durations[index]))")
                                }
                                
                            }
                            .frame(width: 80)
                            .padding()
                            
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
        }
        .padding()
    }

    func formatDuration(_ duration: TimeInterval) -> String {
        // Format the duration as needed, e.g., into minutes and seconds
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "N/A"
    }
}


