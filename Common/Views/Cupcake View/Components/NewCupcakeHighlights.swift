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
                                        .fill(.gray.opacity(0.25))
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
            cover image: Image?,
            price: Double,
            value: Cupcake
        ) {
            self.name = name
            self.description = description.joined(separator: ", ")
            self.price = price
            
            if let image {
                self.cover = image
            } else {
                self.cover = Icon.questionmarkDiamond.systemImage
            }
            
            self.cupcake = value
        }
    }
}

import SwiftData
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try? ModelContainer(for: Cupcake.self, configurations: config)
    
    guard let container else { return CupcakeView(inMemoryOnly: true) }
    
    let context = ModelContext(container)
    
    let cupcake = Cupcake.sampleCupcakes[0]
    
    context.insert(cupcake)
    
    print("Cupcake Saved")
    
    try? context.save()
    
    return CupcakeView.NewCupcakeHighlights(
        name: "Chocolate",
        description: ["Chocolate"],
        cover: Icon.bag.systemImage,
        price: 7.0,
        value: cupcake
    )
    .padding()
}
