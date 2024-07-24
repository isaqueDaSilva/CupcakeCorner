//
//  ProductHighlight.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/04/24.
//

import SwiftUI

extension OrderView {
    struct ProductHighlight: View {
        let flavor: String
        let image: Image
        
        var body: some View {
            VStack {
                Text("Buy the \(flavor) Cupcake")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 150, maxHeight: 150)
                    .padding()
            }
            .frame(maxWidth: .infinity)
        }
        
        init(
            flavor: String,
            image: Image?
        ) {
            self.flavor = flavor
            
            if let image {
                self.image = image
            } else {
                self.image = Icon.questionmarkDiamond.systemImage
            }
        }
    }
}
