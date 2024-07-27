//
//  CupcakeViewLoad.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 11/05/24.
//

import SwiftData
import SwiftUI

extension CupcakeView {
    @ViewBuilder
    func CupcakeViewLoad() -> some View {
        VStack {
            #if CLIENT
            HomeViewMessage()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            if let newestCupcake = viewModel.newestCupcake {
                NewCupcakeHighlights(
                    name: newestCupcake.flavor,
                    description: newestCupcake.ingredients,
                    cover: newestCupcake.image,
                    price: newestCupcake.price,
                    value: newestCupcake
                )
                .padding(.bottom)
            }
            
            Text("Cupcakes")
                .headerSessionText()
                .frame(maxWidth: .infinity, alignment: .leading)
            #endif
            
            LazyVGrid(columns: colums) {
                ForEach($viewModel.cupcakes, id: \.id) { cupcake in
                    NavigationLink {
                        #if CLIENT
                        OrderView(cupcake: cupcake.wrappedValue)
                            .environmentObject(userRepo)
                        #elseif ADMIN
                        CupcakeDetailView(cupcake: cupcake) { cupcakeID in
                            viewModel.deleteCupcake(by: cupcakeID)
                        }
                        #endif
                    } label: {
                        CupcakeCard(
                            name: cupcake.wrappedValue.flavor,
                            image: cupcake.wrappedValue.image
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal)
        .padding([.top, .bottom], 5)
        #if CLIENT
        .navigationTitle("Buy")
        #elseif ADMIN
        .navigationTitle("Cupcakes")
        #endif
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try? ModelContainer(for: Cupcake.self, configurations: config)
    
    guard let container else { return CupcakeView(inMemoryOnly: true) }
    
    let context = ModelContext(container)
    
    for cupcake in Cupcake.sampleCupcakes {
        context.insert(cupcake)
    }
    
    try? context.save()
    print("Cupcakes Saved")
    
    return CupcakeView(inMemoryOnly: true)
        .environment(\.modelContext, context)
        .environmentObject(UserRepositoty())
}
