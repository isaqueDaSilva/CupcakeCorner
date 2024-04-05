//
//  CupcakeCard.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

struct CupcakeCard: View {
    let name: String
    let image: Image
    
    var body: some View {
        ZStack {
            Text(name)
                .font(.headline)
                .bold()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding([.top, .leading])
            
            image
                .resizable()
                .scaledToFit()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.black.opacity(0.2))
                        .frame(height: 250)
                )
                .frame(height: 250)
        }
    }
}
