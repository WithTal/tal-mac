//
//  CircleChart.swift
//  Tal
//
//  Created by Pablo Hansen on 2/17/24.
//

import Foundation

import SwiftUI

// Data model for pie chart segment with label
struct CircleChartData {
    var value: CGFloat
    var color: Color
    var label: String
}


struct CircleChartLegend: View {
    var data: [CircleChartData]
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(data, id: \.label) { entry in
                HStack {
                    Circle()
                        .fill(entry.color)
                        .frame(width: 10, height: 10)
                    Text(entry.label)
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal)
    }
}



// View for a single slice of the pie chart with label
struct PieSliceView: View {
    var data: CircleChartData
    var startAngle: Angle
//    var index: Int
    var endAngle: Angle
    var showLabel: Bool
    
    @State var scale = 0.0

    private var midAngle: Angle {
        Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
    }

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 100, y: 100))
                path.addArc(center: .init(x: 100, y: 100), radius: 100, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(data.color)

            if showLabel {
                Text(data.label)
                    .position(x: 100 + cos(midAngle.radians) * 70, y: 100 + sin(midAngle.radians) * 70)
            }
        }
//        .scaleEffect(scale)
//            .animate(using: .easeInOut(duration: Double(index) * 0.1), delay: Double(index) * 0.1) {
//                scale = 1
//            }
    }

}

extension View {
    func animate(using animation: Animation = .easeInOut(duration: 1), delay: Double = 0, _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation.delay(delay)) {
                action()
            }
        }
    }
}



// View for the complete pie chart
struct CircleChartView: View {
    var data: [CircleChartData]
    
    
    
    let showLabelThreshold = 2

       private var showLabels: Bool {
           data.count <= showLabelThreshold
       }


    private var totalValue: CGFloat {
        data.reduce(0) { $0 + $1.value }
    }

    private func angle(atIndex index: Int) -> Angle {
        let total = data[..<index].reduce(0) { $0 + $1.value }
        return .degrees(total / totalValue * 360 - 90)
    }

    
    var body: some View {
        VStack{
            ZStack {
                
                ForEach(0..<data.count, id: \.self) { index in
                    PieSliceView(data: data[index], startAngle: angle(atIndex: index), endAngle: angle(atIndex: index + 1), showLabel: showLabels)
                        

                }
            }
        }
    }
}
