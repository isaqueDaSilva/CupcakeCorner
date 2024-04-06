//
//  BagViewPopulated.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

extension BagView {
    @ViewBuilder
    func BagViewPopulated() -> some View {
        List {
            ForEach(0..<10) { integer in
                Section {
                    ItemCard(
                        name: "Some Item \(integer + 1)",
                        price: Double.random(in: 1...50)
                    )
                }
                .listRowSeparator(.hidden)
                .listSectionSpacing(0)
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                ActionButton(label: "Finish") { }
            }
            
            ToolbarItem(placement: .bottomBar) {
                SubtotalLabel(15)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BagView().BagViewPopulated()
    }
}
