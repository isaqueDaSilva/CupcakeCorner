//
//  FreeShipping.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension CupcakeView {
    struct HomeViewMessage: View {
        var body: some View {
            HStack(alignment: .top) {
                Icon.shippingBox.systemImage
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    Text("Make your order")
                        .font(.title3)
                        .bold()
                    
                    Text("And receive a free gift when you pick up your order.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    CupcakeView.HomeViewMessage()
}
