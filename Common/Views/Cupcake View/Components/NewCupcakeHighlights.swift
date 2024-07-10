//
//  NewCupcakeHighlights.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension CupcakeView {
    struct NewCupcakeHighlights: View {
        let name: String
        let description: String
        let cover: Image
        let price: Double
        
        let cupcake: Cupcake
        
        var body: some View {
            VStack {
                Text("New")
                    .headerSessionText()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                GroupBox {
                    cover
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom)
                    
                    HStack {
                        Text("From \(price.currency)")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        NavigationLink {
                            OrderView(cupcake: cupcake)
                        } label: {
                            Text("Buy")
                                .foregroundStyle(.blue)
                                .padding([.top, .bottom], 2)
                                .padding(.horizontal, 10)
                                .background(
                                    Capsule()
                                        .fill(.black.opacity(0.1))
                                )
                        }
                    }
                } label: {
                    Text(name)
                    
                    Text("Made with \(description)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        
        init(
            name: String,
            description: [String],
            cover image: UIImage?,
            price: Double,
            value: Cupcake
        ) {
            self.name = name
            self.description = description.joined(separator: ", ")
            self.price = price
            
            if let image {
                self.cover = Image(uiImage: image)
            } else {
                self.cover = Icon.questionmarkDiamond.systemImage
            }
            
            self.cupcake = value
        }
    }
}

//#Preview {
//    CupcakeView.NewCupcakeHighlights(
//        name: "Chocolate",
//        description: ["Chocolate"],
//        cover: UIImage(systemName: Icon.bag.rawValue),
//        price: 7.0,
//        value: Cupcake.sampleCupcakes[0]
//    )
//    .padding()
//}
