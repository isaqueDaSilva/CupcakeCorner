//
//  CupcakeViewLoad.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 11/05/24.
//

import Foundation
import SwiftUI

extension CupcakeView {
    @ViewBuilder
    func CupcakeViewLoad() -> some View {
        ScrollView {
            VStack {
                #if CLIENT
                FreeShipping()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                if let newestCupcake = cacheStorage.newestCupcake {
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
                    ForEach(cacheStorage.storage[0].cupcakes) { cupcake in
                        NavigationLink(value: cupcake) {
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
    }
}
