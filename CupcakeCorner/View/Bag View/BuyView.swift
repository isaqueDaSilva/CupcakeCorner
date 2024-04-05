//
//  BuyView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct BuyView: View {
    let colums: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    FreeShipping()
                }
                .listRowSeparator(.hidden, edges: .bottom)
                
                Section {
                    NewCupcakeHighlights(
                        name: "Name",
                        description: "Description",
                        price: 5
                    )
                } header: {
                    Text("New")
                        .headerSessionText()
                }
                .listRowSeparator(.hidden)
                
                Section {
                    LazyVGrid(columns: colums) {
                        ForEach(0..<10) { index in
                            CupcakeCard(
                                name: "\(index + 1)",
                                image: Icon.house.systemImage
                            )
                        }
                    }
                } header: {
                    Text("Cupcakes")
                        .headerSessionText()
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Buy")
            .toolbar {
                Button {
                    
                } label: {
                    Icon.personCircle.systemImage
                        .font(.title3)
                }
            }
        }
    }
}

#Preview {
    BuyView()
}
