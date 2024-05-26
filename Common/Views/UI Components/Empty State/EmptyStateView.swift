//
//  EmptyStateView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/05/24.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let description: String
    let icon: Icon
    
    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: icon.rawValue,
            description: Text(description)
        )
    }
    
    init(title: String, description: String, icon: Icon) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}

#Preview {
    EmptyStateView(
        title: "Something",
        description: "somthing",
        icon: .bag
    )
}
