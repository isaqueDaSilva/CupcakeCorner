//
//  CupcakeCard.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension BuyView {
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
    }
}

#Preview {
    BuyView.CupcakeCard(name: "Dummy Name", image: Icon.house.systemImage)
        
}
