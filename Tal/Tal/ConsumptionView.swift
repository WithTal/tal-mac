//
//  ConsumptionView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/15/24.
//

import Foundation

import SwiftUI
import Charts


struct ToyShape: Identifiable {
    var color: String
    var type: String
    var count: Double
    var id = UUID()
}

var data: [ToyShape] = [
    .init(color: "Green", type: "Cube", count: 5),
    .init(color: "Green",type: "Sphere", count: 4),
    .init(color: "Red",type: "Sphere", count: 4),
    .init(color: "Green",type: "Pyramid", count: 4)
]


struct BarChart: View {
    var body: some View {
        Chart {
            ForEach(data) { shape in
                BarMark(
                    x: .value("Shape Type", shape.type),
                    y: .value("Total Count", shape.count)
                )
                .foregroundStyle(by: .value("Shape Color", shape.color))
            }
        }
    }
}
