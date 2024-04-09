//
//  SubtotalLabel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

struct InformationLabel: View {
    let title: String
    let subtotal: Double
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(subtotal.currency)
        }
    }
    
    init(
        title: String = "Subtotal",
        _ subtotal: Double
    ) {
        self.title = title
        self.subtotal = subtotal
    }
}

#Preview {
    InformationLabel(15)
        .padding()
}
