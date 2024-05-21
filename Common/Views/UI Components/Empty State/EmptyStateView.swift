//
//  EmptyStateView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/05/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            BagViewTexts.contentUnavaiableTitle.rawValue,
            systemImage: Icon.bag.rawValue,
            description: Text(description.rawValue)
        )
    }
}

#Preview {
    EmptyStateView()
}
