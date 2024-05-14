//
//  ItemCard.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
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
}

#Preview {
    ItemCard(
        name: "Some Name",
        description: UUID().uuidString, 
        image: Image(systemName: Icon.house.rawValue),
        price: 15
    )
    .padding()
}
