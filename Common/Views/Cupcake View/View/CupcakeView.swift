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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    #if CLIENT
                    FreeShipping()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    if let newestCupcake = viewModel.newestCupcake {
                        Text("New")
                            .headerSessionText()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        NewCupcakeHighlights(
                            name: newestCupcake.flavor,
                            description: newestCupcake.ingredients,
                            cover: newestCupcake.coverImage,
                            price: newestCupcake.price
                        ) {
                            #if CLIENT
                            OrderView(cupcake: newestCupcake)
                            #elseif ADMIN
                            CupcakeDetailView(cupcake: newestCupcake)
                            #endif
                        }
                        .padding(.bottom)
                    }
                    #endif
                             
                    #if CLIENT
                    Text("Cupcakes")
                        .headerSessionText()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    #endif
                    
                    LazyVGrid(columns: colums) {
                        ForEach(viewModel.cupcakes) { cupcake in
                            NavigationLink {
                                #if CLIENT
                                OrderView(cupcake: cupcake)
                                #elseif ADMIN
                                CupcakeDetailView(cupcake: cupcake)
                                #endif
                            } label: {
                                CupcakeCard(
                                    name: cupcake.flavor,
                                    imageData: cupcake.coverImage
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)
                .padding([.top, .bottom], 5)
            }
            #if CLIENT
            .navigationTitle("Buy")
            #elseif ADMIN
            .navigationTitle("Cupcakes")
            .toolbar {
                Button {
                    viewModel.showingCreateNewCupcakeView = true
                } label: {
                    Icon.plusCircle.systemImage
                }
            }
            .sheet(isPresented: $viewModel.showingCreateNewCupcakeView) {
                CreateCupcakeView()
            }
            #endif
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    CupcakeView(inMemoryOnly: true)
}
