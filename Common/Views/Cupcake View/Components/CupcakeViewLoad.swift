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
                
                if let newestCupcake = viewModel.newestCupcake() {
                    NewCupcakeHighlights(
                        name: newestCupcake.wrappedFlavor,
                        description: newestCupcake.wrappedIngredients,
                        cover: newestCupcake.wrappedCoverImage,
                        price: newestCupcake.price,
                        value: newestCupcake
                    )
                    .padding(.bottom)
                }
                #endif
                         
                #if CLIENT
                Text("Cupcakes")
                    .headerSessionText()
                    .frame(maxWidth: .infinity, alignment: .leading)
                #endif
                
                LazyVGrid(columns: colums) {
                    ForEach(viewModel.cupcakes, id: \.id) { cupcake in
                        NavigationLink(value: cupcake) {
                            CupcakeCard(
                                name: cupcake.wrappedFlavor,
                                image: cupcake.wrappedCoverImage
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
