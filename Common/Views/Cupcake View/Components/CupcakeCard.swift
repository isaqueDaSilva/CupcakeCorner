//
//  CupcakeCard.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension CupcakeView {
    struct CupcakeCard: View {
        let name: String
        let image: Image
        
        var body: some View {
            GroupBox(name) {
                image
                    .resizable()
                    .scaledToFit()
            }
        }
        
        init(
            name: String,
            image: Image
        ) {
            self.name = name
            
            self.image = image
        }
    }
}

#Preview {
    CupcakeView.CupcakeCard(
        name: "Chocolate",
        image: Icon.bag.systemImage
    )
    .padding()
}
