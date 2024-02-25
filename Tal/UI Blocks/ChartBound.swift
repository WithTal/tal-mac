//
//  CardBound.swift
//  Tal
//
//  Created by Pablo Hansen on 2/17/24.
//

import Foundation
import SwiftUI



struct CardView<Content: View>: View {
    let content: Content
    var backgroundColor: Color
    
    

    init( backgroundColor: Color, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
    }
}
