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


struct VistanteGridView: View {
    @ObservedObject var viewModel: AppsModel
    @ObservedObject var websiteViewModel: WebsitesModel
    
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


