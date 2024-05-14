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
                    BuyText.freeShippingTitle.text
                        .font(.title3)
                        .bold()
                    
                    BuyText.freeShippingDescription.text
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
