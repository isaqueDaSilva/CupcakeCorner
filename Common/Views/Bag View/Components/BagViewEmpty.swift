//
//  BagViewEmpty.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

extension BagView {
    @ViewBuilder
    func BagViewEmpty(with description: BagViewTexts = .contentUnavaiableDescription) -> some View {
        EmptyStateView(
            title: "No orders in bag",
            description: description.rawValue,
            icon: .bag
        )
    }
}

#Preview {
    BagView().BagViewEmpty()
}
