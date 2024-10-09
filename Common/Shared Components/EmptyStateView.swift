//
//  EmptyStateView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/27/24.
//

import SwiftUI

/// A default empty view style.
struct EmptyStateView: View {
    let title: String
    let description: String
    let icon: Icon
    
    var body: some View {
        VStack {
            ContentUnavailableView(
                title,
                systemImage: icon.rawValue,
                description: Text(description)
            )
        }
    }
    
    init(
        title: String,
        description: String,
        icon: Icon
    ) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}

#Preview {
    EmptyStateView(
        title: "There are no item saved",
        description: "Please try again later",
        icon: .magnifyingglass
    )
}
