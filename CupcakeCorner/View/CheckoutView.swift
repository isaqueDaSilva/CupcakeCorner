//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    InformationLabel(
                        15, 
                        isBoldText: false,
                        title: "Subtotal of Bag:"
                    )
                    
                    InformationLabel(
                        0,
                        isBoldText: false,
                        title: "Shipping:"
                    )
                    
                    InformationLabel(
                        15,
                        isBoldText: false,
                        title: "Total:"
                    )
                } header: {
                    Text("Resume")
                        .headerSessionText()
                }
                .listRowBackground(Color(uiColor: .systemGray6))
                
                Section {
                    LabeledContent("Send For:", value: "Tim Cook")
                    LabeledContent("Street:", value: "One Apple Park Way")
                    LabeledContent("City:", value: "Cupertino")
                    LabeledContent("Zip Code:", value: "CA 95014")
                    LabeledContent("Payment Method:", value: "Credit Card")
                } header: {
                    Text("User Information")
                        .headerSessionText()
                }
                .listRowBackground(Color(uiColor: .systemGray6))
                
                Section {
                    Text("Payment must be made at the time of delivery of the purchase by card or cash.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CancelButton { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    ActionButton(label: "Finish Order") { }
                }
            }
        }
    }
}

#Preview {
    CheckoutView()
}
