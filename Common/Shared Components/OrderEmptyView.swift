//
//  OrderEmptyView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//

import SwiftUI

struct OrderEmptyView: View {
    let description: OrderText
    
    var body: some View {
        EmptyStateView(
            title: "No orders",
            description: description.rawValue,
            icon: .bag
        )
    }
    
    init(with description: OrderText = .contentUnavaiableDescription) {
        self.description = description
    }
}

#Preview {
    OrderEmptyView()
}
