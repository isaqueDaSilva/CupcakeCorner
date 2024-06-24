//
//  EmptyStateView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/05/24.
//

import SwiftUI

/// A default empty view style.
struct EmptyStateView: View {
    let title: String
    let description: String
    let icon: Icon
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            ContentUnavailableView(
                title,
                systemImage: icon.rawValue,
                description: Text(description)
            )
        }
        .toolbar {
            Button {
                action()
            } label: {
                Icon.arrowClockwise.systemImage
            }
            
        }
    }
    
    init(
        title: String,
        description: String,
        icon: Icon,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.action = action
    }
}

#Preview {
    NavigationStack {
        EmptyStateView(
            title: "Something",
            description: "somthing",
            icon: .bag
        ) { }
    }
}
