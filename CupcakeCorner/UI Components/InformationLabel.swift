//
//  SubtotalLabel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

struct InformationLabel: View {
    let title: String
    let isBoldText: Bool
    let subtotal: Double
    
    var body: some View {
        HStack(alignment: .top) {
            Group {
                if isBoldText {
                    Text(title)
                        .font(.title3)
                        .bold()
                } else {
                    Text(title)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(subtotal.currency)
        }
    }
    
    init(
        _ subtotal: Double,
        isBoldText: Bool = true,
        title: String = "Subtotal"
    ) {
        self.title = title
        self.isBoldText = isBoldText
        self.subtotal = subtotal
    }
}

#Preview {
    InformationLabel(15)
        .padding()
}
