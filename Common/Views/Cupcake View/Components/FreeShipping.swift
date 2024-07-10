//
//  FreeShipping.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension CupcakeView {
    struct FreeShipping: View {
        var body: some View {
            HStack(alignment: .top) {
                Icon.shippingBox.systemImage
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    Text("Free Shipping")
                        .font(.title3)
                        .bold()
                    
                    Text("From Friday to Sunday, in all locations in Cupertino.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    CupcakeView.FreeShipping()
}
