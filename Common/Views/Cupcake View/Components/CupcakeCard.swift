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
            
            VStack {
                Text(name)
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding([.leading, .top])
                
                image
                    .resizable()
                    .scaledToFit()
            }
            .padding(2)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.black.opacity(0.08))
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
