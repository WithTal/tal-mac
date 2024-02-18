//
//  Experimental.swift
//  Tal
//
//  Created by Pablo Hansen on 2/17/24.
//

import Foundation
import SwiftUI
import SwiftUI
import Charts

import SwiftUI




struct ExperimentalView: View {
    // Expanded data for websites
    let websitesData = [
        CircleChartData(value: 30, color: .orange, label: "Reddit"),
        CircleChartData(value: 20, color: .blue, label: "Google"),
        CircleChartData(value: 15, color: .purple, label: "YouTube"),
        CircleChartData(value: 10, color: .pink, label: "Instagram"),
        CircleChartData(value: 8, color: .green, label: "Wikipedia"),
        CircleChartData(value: 7, color: .yellow, label: "Twitter"),
        CircleChartData(value: 5, color: .gray, label: "LinkedIn"),
        CircleChartData(value: 5, color: .red, label: "Amazon"),
        // Add more websites as needed
    ]

    // Expanded data for apps
    let appsData = [
        CircleChartData(value: 30, color: .red, label: "Netflix"),
        CircleChartData(value: 20, color: .green, label: "Notes"),
        CircleChartData(value: 15, color: .blue, label: "Safari"),
        CircleChartData(value: 10, color: .yellow, label: "Mail"),
        CircleChartData(value: 8, color: .purple, label: "Messages"),
        CircleChartData(value: 7, color: .pink, label: "Music"),
        CircleChartData(value: 5, color: .orange, label: "Photos"),
        CircleChartData(value: 5, color: .gray, label: "Calendar"),
        // Add more apps as needed
    ]
    
    let categoriesData = [
        CircleChartData(value: 60, color: .red, label: "Social Media"),
        CircleChartData(value: 20, color: .green, label: "Work"),
        CircleChartData(value: 15, color: .black, label: "Journal"),
        CircleChartData(value: 10, color: .blue, label: "Texting"),
        // Add more apps as needed
    ]

    func nextDay() {
        print("ImPLEMENT")
    }

    func previousDay() {
        print("ImPLEMENT")
    }

    
    var body: some View {
        HStack {
            Button(action: previousDay) {
                Image(systemName: "arrow.left")
            }

            Text("Feb 17")
                .fontWeight(.bold)

            Button(action: nextDay) {
                Image(systemName: "arrow.right")
            }
        }

        Text("Today: 8h") // Replace this with dynamic data based on currentDate if needed

        HStack (alignment: .top){
            CardView(backgroundColor: Color(red: 0.3, green: 0.0, blue: 0.4)
, content: {
                VStack{
                    Text("Applications").font(.title2)
                    CircleChartView(data: appsData)
                        .frame(width: 200, height: 200)
                    CircleChartLegend(data:appsData)
                }
            })
            
            CardView(backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.44)
, content: {   VStack{
                Text("Websites").font(.title2)
                CircleChartView(data: websitesData)
                    .frame(width: 200, height: 200)
                CircleChartLegend(data:websitesData)
                
            }}
                )
            CardView(backgroundColor: Color(red: 0.0, green: 0.5, blue: 0.5)
, content: {   VStack{
                Text("Categories").font(.title2)
                CircleChartView(data: categoriesData)
                    .frame(width: 200, height: 200)
                CircleChartLegend(data:categoriesData)
            }
            })
            
        }
        
    }
}

