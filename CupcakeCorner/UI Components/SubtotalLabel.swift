//
//  SubtotalLabel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

struct SubtotalLabel: View {
    let subtotal: Double
    
    var body: some View {
        HStack(alignment: .top) {
            Text("Subtotal:")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(subtotal.currency)
        }
    }
    
    init(_ subtotal: Double) {
        self.subtotal = subtotal
    }
}

#Preview {
    SubtotalLabel(15)
        .padding()
}
