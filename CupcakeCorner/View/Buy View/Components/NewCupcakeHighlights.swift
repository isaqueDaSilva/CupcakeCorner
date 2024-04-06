//
//  NewCupcakeHighlights.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension BuyView {
    struct NewCupcakeHighlights: View {
        let name: String
        let description: String
        let price: Double
        
        var body: some View {
            GroupBox {
                Icon.house.systemImage
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom)
                
                HStack {
                    Text("From \(price.currency)")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button{
                        
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
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
#Preview {
    BuyView.NewCupcakeHighlights(name: "Name", description: "Description", price: 10)
}
