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
                    Text("New")
                        .headerSessionText()
                    
                    NewCupcakeHighlights(
                        name: "Name",
                        description: "Description",
                        price: 5
                    )
                }
                .listRowSeparator(.hidden)
                
                Section {
                    Text("Cupcakes")
                        .headerSessionText()
                    
                    LazyVGrid(columns: colums) {
                        ForEach(0..<10) { index in
                            CupcakeCard(
                                name: "\(index + 1)",
                                image: Icon.house.systemImage
                            )
                        }
                    }
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
