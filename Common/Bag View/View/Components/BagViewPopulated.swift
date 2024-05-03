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
            
            Section {
                HStack(alignment: .top) {
                    Text("Shipping Address:")
                    
                    VStack(alignment: .trailing) {
                        Text("Name")
                        Text("Street")
                        Text("City")
                        Text("ZIP Code")
                    }
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                LabeledContent("Payment Method:", value: "Credit Card")
                
                VStack {
                    InformationLabel(15)
                    InformationLabel(0, title: "Shipping")
                    InformationLabel(15, title: "Total")
                }
            } header: {
                Text("Resume")
                    .headerSessionText()
            }
            .listRowSeparator(.visible, edges: .all)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                //ActionButton(label: "Finish") { }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BagView().BagViewPopulated()
    }
}
