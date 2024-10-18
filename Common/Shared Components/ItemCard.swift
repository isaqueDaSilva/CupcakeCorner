//
//  ItemCard.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//

import SwiftUI

struct ItemCard: View {
    let name: String
    let description: String
    let image: Image
    let price: Double
    
    var body: some View {
        GroupBox {
            HStack(alignment: .top) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(name)
                            .font(.headline)
                        
                        Text(price.currency)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.bottom)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }
    }
    
    init(
        name: String,
        description: String,
        image: Image?,
        price: Double
    ) {
        self.name = name
        self.description = description
        
        if let image {
            self.image = image
        } else {
            self.image = Icon.questionmarkDiamond.systemImage
        }
        
        self.price = price
    }
}

#Preview {
    ItemCard(
        name: "Dummy Item",
        description: "Dummy Description",
        image: Icon.bag.systemImage,
        price: 5.0
    )
    .padding()
}
