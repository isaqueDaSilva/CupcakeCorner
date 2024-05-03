//
//  BuyView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct CupcakeView: View {
    let colums: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    @StateObject private var viewModel: ViewModel
    @State private var navigation = Navigation<Cupcake>()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            List {
                #if CLIENT
                Section {
                    FreeShipping()
                }
                .listRowSeparator(.hidden, edges: .bottom)
                
                
                Section {
                    if let newestCupcake = viewModel.newestCupcake {
                        Text("New")
                            .headerSessionText()
                        
                        NewCupcakeHighlights(
                            name: newestCupcake.flavor,
                            description: newestCupcake.ingredients,
                            cover: newestCupcake.coverImage,
                            price: newestCupcake.price
                        ) {
                            navigation.append(newestCupcake)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                #endif
                
                Section {
                    #if CLIENT
                    Text("Cupcakes")
                        .headerSessionText()
                    #endif
                    LazyVGrid(columns: colums) {
                        ForEach(viewModel.cupcakes) { cupcake in
                            VStack {
                                Button {
                                    navigation.append(cupcake)
                                } label: {
                                    CupcakeCard(
                                        name: cupcake.flavor,
                                        imageData: cupcake.coverImage
                                    )
                                }
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            #if CLIENT
            .navigationTitle("Buy")
            #elseif ADMIN
            .navigationTitle("Cupcakes")
            #endif
            .navigationDestination(for: Cupcake.self) { cupcake in
                #if CLIENT
                OrderView(
                    flavor: cupcake.flavor,
                    id: cupcake.id,
                    coverImageData: cupcake.coverImage,
                    price: cupcake.price
                )
                #elseif ADMIN
                CupcakeView(cupcake: cupcake)
                #endif
                
            }
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: ViewModel(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    CupcakeView(inMemoryOnly: true)
}
